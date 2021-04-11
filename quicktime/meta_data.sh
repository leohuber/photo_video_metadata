#!/bin/bash

video_file=$1
id=""
meta_files=""
processed=false
meta_file=""

error_exit() {
  echo "$1" 1>&2
  exit 1
}

fetch_meta_files() {
	meta_files=`ls ./meta/*.txt 2> /dev/null` || error_exit "Could not load meta files"
}

check_video_file_exists() {
	ls ${1}  &> /dev/null || error_exit "Could not find file: ${1}"
}

fetch_identifier() {
	id=$(echo $1 | cut -c1-15)
}

cleanup_vars() {
	unset IDENTIFIER
	unset SOFTWARE
	unset MODEL
	unset MAKE
	unset GPS
	unset COMMENT
	unset SUBLOCATION
	unset STATE
	unset CITY
	unset COUNTRY
	unset COUNTRY_CODE
	unset TITLE_SUFFIX
	unset DESCRIPTION
	unset COPYRIGHT
	unset PERSON_SHOWN
	unset EVENT
	unset DATE_CREATED
}

set_quicktime_keys_tags() {

	# Update keys tags and delete Keys:DisplayName (added by FilmicPro)
	exiftool -overwrite_original -Keys:Make="${MAKE}" -Keys:Model="${MODEL}" -Keys:Software="${SOFTWARE}" \
		-Keys:Description="${DESCRIPTION}" -Keys:Comment="${COMMENT}" -Keys:GPSCoordinates="${GPS}" \
		-Keys:CreationDate="${DATE_CREATED}" -Keys:DisplayName= $video_file &> /dev/null || error_exit "Could not update quicktime keys tags"

	# When updating the field "Copyright Notice", Adobe Bridge updates both, the xmp filed "xmp:Rights" and the field "itemlist:Copyright" with the same value.
	# Therefore ,make sure both fields are updated. The same holds for the fields "xmp:Title" / "itemlist:Title" and "xmp:LogComment" / "itemlist:Comment"
	exiftool -overwrite_original -itemlist:Copyright="${COPYRIGHT}" -itemlist:Title="${IDENTIFIER}_${TITLE_SUFFIX}" -itemlist:Comment="${COMMENT}" \
		$video_file &> /dev/null || error_exit "Could not update quicktime keys tags"
}

set_xmp_dm_tags() {
	exiftool -if "defined($SourceImageHeight)" -overwrite_original "-xmp:VideoFrameSizeH<SourceImageHeight" $video_file &> /dev/null || error_exit "Could not update tag: xmp:VideoFrameSizeH"
	exiftool -if "defined($SourceImageWidth)" -overwrite_original "-xmp:VideoFrameSizeW<SourceImageWidth" $video_file &> /dev/null || error_exit "Could not update tag: xmp:VideoFrameSizeW"
	exiftool -if "defined($VideoFrameRate)" -overwrite_original "-xmp:VideoFrameRate<VideoFrameRate" $video_file &> /dev/null || error_exit "Could not update tag: xmp:VideoFrameRate"
	exiftool -if "defined($CompressorName)" -overwrite_original "-xmp:VideoCompressor<CompressorName" $video_file &> /dev/null || error_exit "Could not update tag: xmp:VideoCompressorName"
	exiftool -overwrite_original -xmp:VideoFrameSizeUnit="pixels" -xmp:LogComment="${COMMENT}" $video_file &> /dev/null || error_exit "Could not update tag: xmp:VideoFrameSizeUnit or xmp:LogComment"
}

set_xmp_core_schema_tags() {
	exiftool -overwrite_original -xmp:CountryCode="${COUNTRY_CODE}" -xmp:Country="${COUNTRY}" -xmp:State="${STATE}" -xmp:City="${CITY}" \
	-xmp:Location="${SUBLOCATION}" -xmp:Title="${IDENTIFIER}_${TITLE_SUFFIX}" -xmp:Headline="${HEADLINE}" -xmp:Description="${DESCRIPTION}" \
	-xmp:DateCreated="${DATE_CREATED}" -xmp:Marked="True" -xmp:Rights="${COPYRIGHT}" \
	$video_file &> /dev/null || error_exit "Could not update xmp core schema tags"
}

set_xmp_extension_schema_tags() {
	exiftool -overwrite_original -xmp:LocationShownCountryCode="${COUNTRY_CODE}" -xmp:LocationShownCountryName="${COUNTRY}" -xmp:LocationShownProvinceState="${STATE}" \
	-xmp:LocationShownCity="${CITY}" -xmp:LocationShownSublocation="${SUBLOCATION}" -xmp:Event="${EVENT}" -xmp:PersonInImage="${PERSON_SHOWN}" \
	$video_file &> /dev/null || error_exit "Could not update xmp extension schema tags"

	# TODO --> Person in image somehow should be a list ...
	# exiftool -overwrite_original -xmp:DigitalSourceType="http://cv.iptc.org/newscodes/digitalsourcetype/digitalCapture" $video_file &> /dev/null || error_exit "Could not update tag: xmp:DigitalSourceType"
}

set_xmp_tiff_namespace_tags() {
	exiftool -overwrite_original -xmp:Model="${MODEL}" -xmp:Make="${MAKE}" -xmp:ImageDescription="${DESCRIPTION}" $video_file &> /dev/null || error_exit "Could not update xmp tiff namespace tags"
}


check_video_file_exists $video_file
fetch_identifier $video_file
fetch_meta_files

# Check if there is a metadata file with a corresponding identifier
for file in $meta_files
do
	source $file
	if [ "$id" == "$IDENTIFIER" ]; then
		meta_file=$file
		processed=true
		break
	fi
	cleanup_vars
done

if ! $processed; then
	error_exit "Could not find meta data for identifier: ${id}"
fi

# Set XMP Dynamic Media Tags
set_xmp_dm_tags

# Set Quicktime Keys Tags
set_quicktime_keys_tags

# Set XMP Core Schema Tags
set_xmp_core_schema_tags

# Set XMP Extension Schema Tags
set_xmp_extension_schema_tags

# Set XMP Tiff Namespace Tags
set_xmp_tiff_namespace_tags

# Rename meta data file
mv $video_file ${IDENTIFIER}_${TITLE_SUFFIX}.mov

# Rename movie file
mv $meta_file ./meta/${IDENTIFIER}_${TITLE_SUFFIX}.txt

