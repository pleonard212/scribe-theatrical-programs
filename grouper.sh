#!/bin/bash
# This parses the "scrapedfindingaid.csv" file to produce both the subject lists
# as well as the semantic groups (actually just the box/folder sets in the finding aid.)
#
# First, we set up the Internal Field Separator (IFS) to be a comma, to work with CSVs.
IFS=','
# Next, write a header to the groups.csv file (and as a side effect, erase it to start over).
echo 'key,name,description,cover_image_url,external_url,meta_data_1,meta_data_2,retire_count' > groups.csv
# The format of this file is given here: https://github.com/zooniverse/scribeAPI/wiki/Project-Subjects#groups
# We are using two special metadata fields for first and last year of each box/folder set.
# meta_data_1 = first year
# meta_data_2 = last year.
#
# Read the five columns from scrapedfindingaid.csv
while read f1 f2 f3 f4 f5
# For each line, do some things.
do
		# Tell the user which line we're processing
		echo "======================================"
        echo 'Now Processing Box '$f1', Folder '$f2 
        # Our folder values are often given as a range of multiple folders (ex: 19-22).
        # Split the folder values into two variables, the first and last folder.
		STARTFOLDER=${f2%-*}
		ENDFOLDER=${f2##*-}
		# Provide feedback for the user.
        echo 'The first Folder in this set is '$STARTFOLDER
        echo 'The last Folder in this set is '$ENDFOLDER
		# Write the metadata about each box/folder group to groups.csv.  The headers for 
		# this file are shown above in line 8.
        echo 'b'$f1'f'$f2',Box '$f1' Folder '$f2','$f3',b'$f1'f'$f2'.jpg,,'$f4','$f5',99' >> groups.csv
		# Create the csv file for this particular group of box and folders, for example b1f2-3.csv. 
        touch 'groups/group_F'$f1'B'$f2'.csv'
        # Now we're ready to parse through each folder in this group and add it its images
        # to its csv file.
        # Set a counter that starts with the first folder in the set.
        i=$STARTFOLDER
		
        # While we are less than, or equal to the last folder in the set,...
        while [ $i -le $ENDFOLDER ]; do
        	# Tell the user where we are in the process.
			echo 'Now working on Folder '$i
			# To successfully substitue these box and folder variables in a filename, we'll need
			# to pad them with 3 places of zeros.
        	printf -v PADDEDFOLDER "%03d" $i
       		printf -v PADDEDBOX "%03d" $f1
       		# We'll define programs as any items that start with p0001.tif.
			# Look for TIF's that match the pattern. Case-insensitive. Build an array.
			items="$(find /Volumes/DHLabDrobo/DRA37 -iname 'DRA037-S01-b'$PADDEDBOX'-F'$PADDEDFOLDER'-i*-p0001.tif')"
			if [ ! -z "$items" ]
			then
				for item in "${items[@]}";
					do 
						itemfilename=$(basename "$item")
						itemsearch="${itemfilename%-*}"
						echo 'Looking for all pages of '$itemsearch
						touch items/$itemsearch.csv
						PAGECOUNT=1
						find /Volumes/DHLabDrobo/DRA37 -iname "$itemsearch*.tif" | while read page; do
							# TODO convert these mongo tifs into reasonable jpg's.
							# TODO extract the width and height after we resize.
							# http://unix.stackexchange.com/questions/75635/shell-command-to-get-pixel-size-of-an-image
							PAGEJPG=$(basename "$page" | cut -d. -f1)
							echo $PAGECOUNT,$PAGEJPG.jpg,thumbs/$PAGEJPG.jpg,width,height >>  items/$itemsearch.csv
							PAGECOUNT=$[PAGECOUNT + 1]

						done
				done 
			else
				echo '*** ALERT: FOLDER '$PADDEDFOLDER' IS MISSING on the drive.'
			fi			
			# Add one to move on to the next folder in the group.
			let i=i+1 
			
		done




done < scrapedfindingaid.csv
