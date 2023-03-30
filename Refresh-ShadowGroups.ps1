# Syntax:
# <distinguishedName of OU> = <AD Group Name>

$OUtoGroupList = @{
    "OU=OU1,OU=Benutzer,DC=frankysweblab,DC=de" = "ShadowGroup_OU1"
    "OU=OU2,OU=Benutzer,DC=frankysweblab,DC=de" = "ShadowGroup_OU2"
}

$OUtoGroupList.GetEnumerator() | ForEach-Object {
	$Group =  $_.value
	$OU = $_.key
	try {
		write-output "---> Processing OU $OU"
		$Users = Get-ADUser -Filter * -SearchBase $OU | select DistinguishedName
		$GroupMembers = Get-ADGroup $Group | Get-ADGroupMember | select DistinguishedName
		$CompareGroupMembership = Compare-Object -ReferenceObject $GroupMembers.DistinguishedName -DifferenceObject $users.DistinguishedName
	} catch {}

	
	if ($Users -and $CompareGroupMembership) {
		#Update group membership if OU contains users
		$UsersToAdd = $CompareGroupMembership | where {$_.SideIndicator -eq "=>"}
		foreach ($UsertoAdd in $UsersToAdd) {
			$UserDN = $UsertoAdd.InputObject
			write-output " Add user $user to group $group"
			Add-ADGroupMember -Identity $Group -Members $UserDN -confirm:$false
		}
	
		#Remove stalled users from group
		$UsersToRemove = $CompareGroupMembership | where {$_.SideIndicator -eq "<="}
		foreach ($UserToRemove in $UsersToRemove) {
			$UserDN = $UserToRemove.InputObject
			write-output " Remove user $UserDN from group $group"
			Remove-ADGroupMember -Identity $Group -Members $UserDN -confirm:$false
		}
	}
	elseif ($Users -and !$CompareGroupMembership) {
		#Add all users from OU to Group (if group was empty)
		write-output " Add all users to group $Group, group was empty"
		$Users | ForEach-Object { Add-ADGroupMember -Identity $Group -Members $_ }
	}
	elseif (!$Users) {
		#If no users in OU, delete all members from group
		write-output " No Users in OU $OU found, delete all members from group $Group"
		Get-ADGroup $Group | Set-ADGroup -clear member
	}
}