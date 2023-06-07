elseif ($type -eq "securestring") {

$vsoAttribs += 'isSecret=true'

} else {

$value = $_.Value.value

}

24

25

26

27

28

29

Write-Output $keyName

Write-Output $value

Write-Output

30

31

32

33

if ($MakeOutput.IsPresent) {

$vsoAttribs += 'isOutput=true'

}

J

34

1

35

36

37

SattribString = $vsoAttribs $value

$var = "##vso [SattribString] $value"

Write-Output -InputObject $var

38

39

}

mdletBinding(]

2 param (

3

[Parameter (Mandatory)] [ValidateNotNullOrEmpty()]

5

[string] $ArmOutputString,

4

Put

6

7 8

[Parameter()]

[ValidateNotNullOrEmpty()]

[switch] $MakeOutput

9

10

)

11

12

Write-Output "Retrieved Outputs: $ArmOutputString"

SarmOutputObj = $ArmOutputString | Convert From-Json

13

14

15

16

SarmOutputObj.PSObject. Properties | ForEach-Object {

$type = ($_.value.type).ToLower()

$keyname= $_.Name

$vsoAttribs = @("task.setvariable variable=$keyName")

17

18

19

20

21

if ($type -eq "array") {

$value = $_.Value.value.name -join, ## All array va }
elseif ($type -eq "securestring") {
