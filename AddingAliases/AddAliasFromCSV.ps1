#################################################################
# CSV file must be in the same directory as this script		#
# it must be called EmailAliases.csv, and contain at least	#
# two columns, one called UserID and one called Alias1		#
# Additional columns must increment up in number, i.e. Alias2	#
# Alias 3 etc. An example csv has been provided.		#
#################################################################

# Import from the CSV file
$data = Import-Csv EmailAliases.csv 
# Count total number of columns.
$columnCount = ($data | get-member -type NoteProperty).count
# Ignore the first column (the user ID)
$aliasColumns = $columnCount - 1

# for each entry in the csv file
foreach ($a in $data)
{
	# Set counter to 0
	$c = 0
	# While counter is less than alias columns...
	while($c -le $aliasColumns)
	{
		# Capture the alias and put it into string format
		$alias = "Alias" + $c
		
		# if it is a valid string (and not null or empty)...
		if(![string]::IsNullOrEmpty($a.$alias))
		{
			# Add it to the users mailbox  and print a message to screen.
			Set-Mailbox -Identity $a.UserID -EmailAddress @{add=$a.$alias}
			Write-Host ("Successfully added " + $a.$alias + " to " + $a.UserID)
		}
		# Increment the counter.
		$c++
	}
}
