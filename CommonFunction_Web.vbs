'#################################################################################################
'#################################################################################################
'Function name    : Func_Browser_Launch
'Description      : Launch browser
'Parameters       : strBrowserName: name of Browser
'                   strURLAddress: address of website
'Assumptions      : NA 
'sample           : Func_Browser_Launch "IE","https://test.com" Or Func_Browser_Launch "Internet Explorer","https://test.com"
'                   Func_Browser_Launch "FF","https://test.com" Or Func_Browser_Launch "FIREFOX","https://test.com"
'#################################################################################################
'#################################################################################################
Function Func_Browser_Launch(strBrowserName, strURLAddress)

	Select Case UCase(strBrowserName)
		Case "IE", "INTERNET EXPLORER"
			Func_Browser_Launch = SystemUtil.Run("iexplore.exe",strURLAddress)
		Case "FF", "FIREFOX"
			Func_Browser_Launch = SystemUtil.Run("firefox.exe",strURLAddress)
	End Select
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_Browser_Back
'Description      : Back to last page
'Parameters       : intIndex: page you want to operate.
'                   The operation tab is the intIndex+1 tab, eg if the intIndex is 0, the operation object is the first tab.
'Assumptions      : NA 
'sample           : Func_Browser_Back(0)
'#################################################################################################
'#################################################################################################
Function Func_Browser_Back(intIndex)

	If Browser("micclass:=Browser","Index:=" & intIndex).Exist Then
		Browser("micclass:=Browser","Index:=" & intIndex).Back
	End If
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_Browser_CloseTab
'Description      : Close the tab
'Parameters       : intIndex: page you want to operate.
'                   The operation tab is the intIndex+1 tab, eg if the intIndex is 0, the operation object is the first tab.
'Assumptions      : NA 
'sample           : Func_Browser_CloseTab 0
'#################################################################################################
'#################################################################################################
Function Func_Browser_CloseTab(intIndex)

	If Browser("micclass:=Browser","Index:=" & intIndex).Exist Then
		Browser("micclass:=Browser","Index:=" & intIndex).Close
	End If
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_Browser_CheckURLDocumentName
'Description      : Check the document name in URL
'Parameters       : intIndex: page you want to operate,strDocumentName is document name
'                   The operation tab is the intIndex+1 tab, eg if the intIndex is 0, the operation object is the first tab.
'Assumptions      : NA 
'sample           : Func_Browser_CheckURLDocumentName 1,"1095.pdf"
'#################################################################################################
'#################################################################################################
Function Func_Browser_CheckURLDocumentName(intIndex, strDocumentName)
	Dim strTitle
	Dim arrTitle
	Dim intUbound

	If Not Browser("micclass:=Browser","Index:=" & intIndex).Exist Then
		Reporter.ReportEvent micFail, "The specified document is open","The Browser with index "&intIndex&" doesn't exist, please check"
		Exittest
	End If
	
	strTitle = Browser("micclass:=Browser","Index:=" & intIndex).GetROProperty("title")
	
	arrTitle = split(strTitle,"/")
	
	intUbound = Ubound(arrTitle)
	
	If arrTitle(intUbound) = strDocumentName Then
		Reporter.ReportEvent micPass, "The specified document is open","The document "&strDocumentName&" is open in Browser"
	Else
		Reporter.ReportEvent micFail, "The specified document is not open","The document "&strDocumentName&" is not open in Browser"
	End If
	
End Function

'#####################################################################################################
'#################################################################################################
'Function name    : Func_Browser_CloseAll
'Description      : Use the function to close all browsers
'Parameters       : NA
'Assumptions      : NA 
'sample           : Func_Browser_CloseAll
'#################################################################################################
'#################################################################################################
Function Func_Browser_CloseAll
 
  systemutil.CloseProcessByName "iexplore.exe"
  
  'In case of firefox
  systemutil.CloseProcessByName "firefox.exe"
    
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_Description_Generate
'Description      : Generate window description
'Parameters       : strFrameName is name of Frame
'Assumptions      : NA 
'sample           : Set objDescription = Func_Description_Generate("title_frame") or Set objDescription = Func_Description_Generate("")
'#################################################################################################
'#################################################################################################
Function Func_Description_Generate(strFrameName)
	Dim objDescription
	
	'if strFrameName is blank, there is no Frame level
	If strFrameName <> "" Then
		Set objDescription = Browser("micclass:=Browser").Page("micclass:=Page").Frame("name:="&strFrameName)
	Else
		Set objDescription = Browser("micclass:=Browser").Page("micclass:=Page")
	End If
	
	Set Func_Description_Generate = ObjDescription
	
	Set objDescription = Nothing
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebTable_GetRowCount
'Description      : Get rowcount of the webtable
'Parameters       : strFrameName is name of Frame,strTableName is the name of the webtable,intIndex is index of the webtable
'Assumptions      : NA 
'sample           : intRowCount = Func_WebTable_GetRowCount("menu_frame","ABC 101 023/3",0) or intRowCount = Func_WebTable_GetRowCount("","Last name",1)
'#################################################################################################
'#################################################################################################
Function Func_WebTable_GetRowCount(strFrameName,strTableName,intIndex)
	Dim objDescription
	
	Set objDescription = Func_Description_Generate(strFrameName)
	
	'If table doesn't exists, exit the function
	If Not objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).Exist Then
		Reporter.ReportEvent micFail,"Check Table Rows","Table with name "&strTableName&", Index "&intIndex&" doesn't exist, please check"
		Exit Function
	End If
	
	Func_WebTable_GetRowCount = objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).RowCount()
	
	Set objDescription = Nothing
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebTable_CheckExist
'Description      : Get rowcount of the webtable
'Parameters       : strFrameName is name of Frame,strTableName is the name of the webtable,intIndex is index of the webtable
'Assumptions      : NA 
'sample           : Func_WebTable_CheckExist "menu_frame","ABC 101 023/3",0 or Func_WebTable_CheckExist "","Last name",1
'#################################################################################################
'#################################################################################################
Function Func_WebTable_CheckExist(strFrameName,strTableName,intIndex)
	Dim objDescription
	
	Set objDescription = Func_Description_Generate(strFrameName)
	
	'If table doesn't exists, exit the test
	If Not objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).Exist Then
		Reporter.ReportEvent micFail,"Check Table Exists","Table with name "&strTableName&", Location "&intIndex&" doesn't exist, please check"
		ExitTest
	End If
	
	Reporter.ReportEvent micPass, "Check Table Exists","Table with name "&strTableName&", Index "&intIndex&" exists"
	
	Set objDescription = Nothing
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebTable_GetCellData
'Description      : Get rowcount of the webtable
'Parameters       : strFrameName is name of Frame,
'					strTableName is the name of the webtable
'					intIndex is index of the webtable
'					intRow is the row number in webtable
'					intColumn is the column in webtable
'Assumptions      : NA 
'sample           : strValue = Func_WebTable_GetCellData("menu_frame","ABC 101 023/3",0,1,1) or strValue = Func_WebTable_GetCellData("","C",1,2,13)
'#################################################################################################
'#################################################################################################
Function Func_WebTable_GetCellData(strFrameName,strTableName,intIndex,intRow,intColumn)
	On Error Resume Next
	
	Dim objDescription
	
	Set objDescription = Func_Description_Generate(strFrameName)
	
	'If table doesn't exists, exit the function
	If Not objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).Exist Then
		Reporter.ReportEvent micFail,"WebTable doesn't exist","Table with name "&strTableName&", Index "&intIndex&" doesn't exist, please check"
		Exit Function
	End If
	
	Func_WebTable_GetCellData = objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).GetCellData(intRow,intColumn)
	
	Set objDescription = Nothing
	
	On Error Goto 0
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebTable_ClickCellDataLink
'Description      : Click the link in table cell
'Parameters       : strFrameName is name of Frame,
'					strTableName is the name of the webtable
'					intIndex is index of the webtable
'					intRow is the row number in webtable
'					intColumn is the column in webtable
'Assumptions      : NA 
'sample           : Func_WebTable_ClickCellDataLink "","acctest01",1,2,3
'#################################################################################################
'#################################################################################################
Function Func_WebTable_ClickCellDataLink(strFrameName,strTableName,intIndex,intRow,intColumn)
	On Error Resume Next
	
	Dim objDescription
	
	Set objDescription = Func_Description_Generate(strFrameName)
	
	'If table doesn't exists, exit the function
	If Not objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).Exist Then
		Reporter.ReportEvent micFail,"WebTable doesn't exist","Table with name "&strTableName&", Index "&intIndex&" doesn't exist, please check"
		ExitTest
	End If
	
	'Click cell data link
	objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).ChildItem(intRow, intColumn, "Link",0).Click
	
	Set objDescription = Nothing
	
	On Error Goto 0
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebTable_SetWebEditData
'Description      : Set Text for WebEdit in table cell
'Parameters       : strFrameName is name of Frame,
'                    strTableName is the name of the webtable
'                    intIndex is index of the webtable
'                    intRow is the row number in webtable
'                    intColumn is the column in webtable
'                   strText is the data which you want to set
'Assumptions      : NA 
'sample           : Func_WebTable_SetWebEditData "","param",0,2,2,"TestDeleteUser"   
'#################################################################################################
'#################################################################################################
Function Func_WebTable_SetWebEditData(strFrameName,strTableName,intIndex,intRow,intColumn,strText)
    On Error Resume Next
    
    Dim objDescription
    
    Set objDescription = Func_Description_Generate(strFrameName)
    
    'If table doesn't exists, exit the function
    If Not objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).Exist Then
        Reporter.ReportEvent micFail,"WebTable doesn't exist","Table with name "&strTableName&", Index "&intIndex&" doesn't exist, please check"
        ExitTest
    End If
    
    'Set data to cell
    objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).ChildItem(intRow, intColumn, "WebEdit",0).Set strText
    
    Set objDescription = Nothing
    
    On Error Goto 0
    
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebTable_SetCheckBoxValue
'Description      : Set On or Off for CheckBox in table cell
'Parameters       : strFrameName is name of Frame,
'                    strTableName is the name of the webtable
'                    intIndex is index of the webtable
'                    intRow is the row number in webtable
'                    intColumn is the column in webtable
'                   strValue is “on” or “off”
'Assumptions      : NA 
'sample           : Func_WebTable_SetCheckBoxValue  "","Selected",0,2,1,"ON"   
'#################################################################################################
'#################################################################################################
Function Func_WebTable_SetCheckBoxValue (strFrameName,strTableName,intIndex,intRow,intColumn,strValue)
    On Error Resume Next
    
    Dim objDescription

    If UCase(strValue) <> "ON" and UCase(strValue) <> "OFF" Then
        Reporter.ReportEvent micFail, "Func_WebTable_SetCheckBoxValue", "Value only can be ON or OFF, please check the input!"
        ExitTest
    End If
    
    Set objDescription = Func_Description_Generate(strFrameName)
    
    'If table doesn't exists, exit the function
    If Not objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).Exist Then
        Reporter.ReportEvent micFail,"WebTable doesn't exist","Table with name "&strTableName&", Index "&intIndex&" doesn't exist, please check"
        ExitTest
    End If
    
    'Set value to checkbox
    objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).ChildItem(intRow, intColumn, "WebCheckBox",0).Set strValue
    Set objDescription = Nothing
    
    On Error Goto 0
    
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebTable_SelectWebList
'Description      : Select option from WebList in table cell
'Parameters       : strFrameName is name of Frame,
'                    strTableName is the name of the webtable
'                    intIndex is index of the webtable
'                    intRow is the row number in webtable
'                    intColumn is the column in webtable
'                   strOption is the option which you want to select
'Assumptions      : NA 
'sample           : Func_WebTable_SelectWebList "","param",0,2,1,"UserID"   
'#################################################################################################
'#################################################################################################
Function Func_WebTable_SelectWebList(strFrameName,strTableName,intIndex,intRow,intColumn,strOption)
    On Error Resume Next
    
    Dim objDescription
    
    Set objDescription = Func_Description_Generate(strFrameName)
    
    'If table doesn't exists, exit the function
    If Not objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).Exist Then
        Reporter.ReportEvent micFail,"WebTable doesn't exist","Table with name "&strTableName&", Index "&intIndex&" doesn't exist, please check"
        ExitTest
    End If
    
    'Select the option
    objDescription.WebTable("name:="&strTableName,"Index:="&intIndex).ChildItem(intRow, intColumn, "WebList",0).Select strOption
    
    Set objDescription = Nothing
    
    On Error Goto 0
    
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebEdit_SetText
'Description      : Input text on WebEdit
'Parameters       : strFrameName:name of Frame if the webEdit is in the frame
'                   strEditName:name of the WebEdit which you want to input text
'                   strText:the text which you want to input
'Assumptions      : NA 
'sample           : Func_WebEdit_SetText "","User", "Tester" or Func_WebEdit_SetText "title_frame","expr","*"
'#################################################################################################
'#################################################################################################
Function Func_WebEdit_SetText (strFrameName,strEditName,strText)
	Dim objWebEdit
	
	'set objection description
	Set objWebEdit = Func_Description_Generate(strFrameName)
	
	If not objWebEdit.WebEdit("name:="&strEditName).exist Then
		Reporter.ReportEvent micFail,"Can not find ["&strEditName&"] WebEdit", "Pls check your run Enviroment"
		ExitTest
	End If
	
	'if webEdit exists, execute set text
	objWebEdit.WebEdit("name:="&strEditName).Set strText
	
	Set objWebEdit = Nothing
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebEdit_GetText
'Description      : Get text from WebEdit
'Parameters       : strFrameName:name of Frame if the webEdit is in the frame
'                   strEditName:name of the WebEdit which you want to get text
'Assumptions      : NA 
'sample           : Func_WebEdit_GetText ("","User") or Func_WebEdit_GetText ("title_frame","expr") 
'################################################################################################
'#################################################################################################
Function Func_WebEdit_GetText(strFrameName,strEditName)
	Dim objWebEdit
	
	'set objection description
	Set objWebEdit = Func_Description_Generate(strFrameName)
	
	If not objWebEdit.WebEdit("name:="&strEditName).exist Then
		Reporter.ReportEvent micFail,"Can not find ["&strEditName&"] WebEdit", "Pls check your run Enviroment"
		ExitTest
	End If
	
	'if webEdit exists, execute set text
	Func_WebEdit_GetText = objWebEdit.WebEdit("name:="&strEditName).GetROProperty("value")
	
	Set objWebEdit = Nothing
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_Link_Click
'Description      : Click Link
'Parameters       : strFrameName:name of Frame if the Link is in the frame
'                   strLinkName:name of the Link which you want to click
'Assumptions      : NA 
'sample           : Func_Link_Click "","Product Basic" or Func_Link_Click "title_frame","Product Basic"
'################################################################################################
'#################################################################################################
Function Func_Link_Click(strFrameName,strLinkName)
	Dim objLink
	
	Set objLink = Func_Description_Generate(strFrameName)
  
  	If not objLink.Link("name:="&strLinkName).exist  Then
		Reporter.ReportEvent micFail,"Can not find ["&strLinkName&"] Link","Pls check your  Enviroment"
		ExitTest
	End If

   'if Link exists, execute click
	objLink.Link("name:="&strLinkName).Click
	
	Set objLink = Nothing

End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebElement_GetText
'Description      : Get text value from WebElement object
'Parameters       : strFrameName: Frame name
'					strHtmlTag: HTML Tag property
'					strClass: HTML Class property
'Assumptions      : NA
'sample           : Func_WebElement_GetText "", "DIV", "h1"
'#################################################################################################
'#################################################################################################
Function Func_WebElement_GetText(strFrameName, strHtmlTag, strClass)
	On Error Resume Next

	Dim objDescription	
	Set objDescription = Func_Description_Generate(strFrameName)

	If Not objDescription.WebElement("html tag:=" & strHtmlTag ,"class:=" & strClass).Exist Then
		Reporter.ReportEvent micFail, "Func_WebElement_GetText", "Can't find WebElement [html tag:=" & strHtmlTag & ",class:=" & strClass & "], please check the runtime environment!"
		Exit Function
	End If
		
	Func_WebElement_GetText = objDescription.WebElement("html tag:=" & strHtmlTag ,"class:=" & strClass).GetROProperty("innertext")
		
	Set objDescription = Nothing
	
	On Error Goto 0
End Function


'#################################################################################################
'#################################################################################################
'Function name    : Func_WebRadioGroup_SetValue
'Description      : Set value to WebRadioGroup object
'Parameters       : strFrameName: Frame name
'					strRadioGroupName: Web Radio Group Name
'					intIndex: Index of your selection, starting from 0
'Assumptions      : NA
'sample           : Func_WebRadioGroup_SetValue "", "type", 0
'#################################################################################################
'#################################################################################################
Function Func_WebRadioGroup_SetValue(strFrameName, strRadioGroupName, intIndex)
	On Error Resume Next

	Dim objDescription	
	Set objDescription = Func_Description_Generate(strFrameName)
	
	If Not objDescription.WebRadioGroup("html tag:=INPUT","type:=radio","name:=" & strRadioGroupName).Exist Then
		Reporter.ReportEvent micFail, "Func_WebRadioGroup_SetValue", "Can't find WebRadioGroup [name:=" & strRadioGroupName & "], please check the runtime environment!"
		ExitTest
	End If
		
	objDescription.WebRadioGroup("html tag:=INPUT","type:=radio","name:=" & strRadioGroupName).Select "#" & intIndex
	
	Set objDescription = Nothing
	
	On Error Goto 0
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebCheckBox_SetValue
'Description      : Set value to WebCheckBox object
'Parameters       : strFrameName: Frame name
'					strCheckBoxName: Web Check Box Name
'					strValue: Value of the check box, only can be "ON" or "OFF"
'Assumptions      : NA
'sample           : Func_WebCheckBox_SetValue "title_frame", "doc_links", "ON"
'#################################################################################################
'#################################################################################################
Function Func_WebCheckBox_SetValue(strFrameName, strCheckBoxName, strValue)
	On Error Resume Next

	Dim objDescription	
	Set objDescription = Func_Description_Generate(strFrameName)

	If UCase(strValue) <> "ON" and UCase(strValue) <> "OFF" Then
		Reporter.ReportEvent micFail, "Func_WebCheckBox_SetValue", "Value only can be ON or OFF, please check the input!"
		ExitTest
	End If
	
	If Not objDescription.WebCheckBox("html tag:=INPUT","type:=checkbox","name:=" & strCheckBoxName).Exist Then
		Reporter.ReportEvent micFail, "Func_WebCheckBox_SetValue", "Can't find WebCheckBox [name:=" & strCheckBoxName & "], please check the runtime environment!"
		ExitTest		
	End If
		
	objDescription.WebCheckBox("html tag:=INPUT","type:=checkbox","name:=" & strCheckBoxName).Set UCase(strValue)
	
	Set objDescription = Nothing
	
	On Error Goto 0
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebButton_Click
'Description      : detective and click the button
'Parameters       : strFrameName is name of Frame,strButtonName is the name of button
'Assumptions      : NA 
'sample           : Func_WebButton_Click "","help"
'#################################################################################################
'#################################################################################################
Function Func_WebButton_Click (strFrameName, strButtonName )
	Dim objLink
	
	Set objLink = Func_Description_Generate(strFrameName)
	
	If NOT objLink.WebButton("name:="&strButtonName).Exist then
		Reporter.ReportEvent micFail, "Cannot find the button : " + strButtonName,"Pls check your run Enviroment."
		ExitTest
	End if
	
	'Click the button
	objLink.WebButton("name:="&strButtonName).Click
	
	Set objLink = Nothing
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_WebList_Select
'Description      : select weblist value
'Parameters       : strWeblistName is name of weblist,strOptionName is the value want to select
'Assumptions      : NA 
'sample           : Func_WebList_Select "","days","90"
'#################################################################################################
'#################################################################################################
Function Func_WebList_Select (strFrameName, strWeblistName, strOptionName)
	Dim objWebList
	
	set objWebList = Func_Description_Generate(strFrameName)
	
	If Not objWebList.WebList("name:="&strWeblistName).Exist then
		Reporter.ReportEvent micFail, "Cannot find the list : " + strWeblistName,"Pls check your run Enviroment."
		ExitTest
	End If
	
	'Select the text
	objWebList.WebList("name:="&strWeblistName).Select(strOptionName)
	
	Set objWebList = Nothing
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_Image_Click
'Description      : detective and click the image
'Parameters       : strImageAlt the address of the image's link
'Assumptions      : NA 
'sample           : Func_Image_Click "","www.test.com"
'#################################################################################################
'#################################################################################################
Function Func_Image_Click (strFrameName, strImageAlt)
	Dim objImage
	
	set objImage = Func_Description_Generate(strFrameName)
	
	If not objImage.Image("alt:="&strImageAlt).Exist then
		Reporter.ReportEvent micFail, "Cannot find the image : " + strImageAlt,"Pls check your run Enviroment."
		ExitTest
	End If
	
	'Click the image
	objImage.Image("alt:="&strImageAlt).Click
	
	Set objImage = Nothing
	
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_Browser_ChangeURL
'Description      : Change to the target URL
'Parameters       : strTargetURL: URL which you want to navigate to
'Assumptions      : NA 
'sample           : Func_Browser_ChangeURL "https://test.com/"
'#################################################################################################
'################################################################################################  
Function Func_Browser_ChangeURL(strTargetURL)
    
	If not Browser("micclass:=Browser").Exist Then
		Reporter.ReportEvent micFail,"Can not find Browser","Pls check your run Enviroment"
		ExitTest
	End If
    
	Browser("micclass:=Browser").navigate(strTargetURL)

End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_Page_Sync
'Description      : Synchronize actions
'Parameters       : NA
'Assumptions      : NA 
'sample           : Func_Page_Sync
'#################################################################################################
'#################################################################################################
Function Func_Page_Sync
	Dim objPage

    'set objection description
	Set objPage = Browser("micclass:=Browser").Page("micclass:=Page")

	objPage.Sync
	
	Set objPage = Nothing

End Function

'#####################################################################################################
'#################################################################################################
'Function name    : Func_Checkpoint
'Description      : Use the function to check if the actual value match the expected value,  and add result to reporter, If matched return "TRUE" not return "FALSE"
'Parameters       : strActualValue: the actual value of checkpoints actual value
'					strExpectedValue: the expected value of checkpoints actual value
'                   strCompareMode: the method to compare actual value and expected value
'Assumptions      : NA 
'sample           : Func_Checkpoint Func_WebElement_GetText()," Internal","EQUAL"
'#################################################################################################
'#################################################################################################
Function Func_Checkpoint(strActualValue,strExpectedValue,strCompareMode)

    strActualValue = Trim(strActualValue)

	Select Case Ucase(strCompareMode)		
    Case "EQUAL"
		If strActualValue = strExpectedValue Then
			Reporter.ReportEvent micPass, "Check Passed", "Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue				 
		Else
			Reporter.ReportEvent micFail,"Check Failed","Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		End If
				 
	Case "NOTEQUAL"
		If strActualValue <> strExpectedValue Then
			Reporter.ReportEvent micPass,"Check Passed", "Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue				 
		Else
			Reporter.ReportEvent micFail,"Check Failed","Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		End IF
			 
    Case "GREATER"
		If  strActualValue >strExpectedValue  Then
			Reporter.ReportEvent micPass, "Check Passed", "Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue				 
		Else
			Reporter.ReportEvent micFail,"Check Failed","Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		End IF
			 
    Case "LESS"
		If  strActualValue <strExpectedValue  Then
			Reporter.ReportEvent micPass, "Check Passed", "Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue			 
		Else
			Reporter.ReportEvent micFail,"Check Failed","Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		End IF
	Case "GREATEREQUAL"
		If  strActualValue >= strExpectedValue  Then
			Reporter.ReportEvent micPass, "Check Passed", "Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		Else
			Reporter.ReportEvent micFail,"Check Failed","Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		End IF
	Case "LESSEQUAL"
		If  strActualValue <= strExpectedValue  Then
			Reporter.ReportEvent micPass, "Check Passed", "Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		Else
			Reporter.ReportEvent micFail,"Check Failed","Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		End IF
    Case "REGEXP"
		Dim objFlag
		Dim regEx
		Set regEx = New RegExp
		regEx.Pattern = strExpectedValue
		Set objFlag = regEx.Execute(strActualValue)  
		If objFlag.count >0 Then
			Reporter.ReportEvent micPass, "Check Passed", "Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		Else 
			Reporter.ReportEvent micFail,"Check Failed","Expected: " & strExpectedValue & VbCrLf & "Actual: " & strActualValue
		End If
		Set objFlag=Nothing
		Set regEx=Nothing
	
	Case Else 
		Reporter.ReportEvent micFail,  "Call function checkpoint failure, strMode is invalid" , "please give a valid StrMode to continue" 
    End Select
    
End Function

'#################################################################################################
'#################################################################################################
'Function name    : Func_Login
'Description      : Login the test environment
'Parameters       : strSystem is system which you want to login, if need admin access the value is "System_Admin"
'Assumptions      : NA 
'sample           : Func_Login "" or Func_Login "_Admin"
'#################################################################################################
'#################################################################################################
Function Func_Login(strSystem)
	Dim strBrowser
	Dim strURL
	Dim strUser
	Dim strPassword
	
	'Close all open browsers
	Func_Browser_CloseAll
	
	Select Case UCase(strSystem)
	Case ""
		strBrowser = "IE"
		strURL = "https://test.com/"
		strUser = "TestUser"
		strPassword = "Admin123"
		'Lauch Browser
		Func_Browser_Launch strBrowser, strURL
		
		'Input User and Password
		Func_WebEdit_SetText "","USER", strUser
		Func_WebEdit_SetText "","PASSWORD",strPassword
		
		'Click login
		Func_WebButton_Click "","Login"
		
		'If test area page not display, exittest
		If NOT Func_WebElement_GetText("","SPAN","h1Sub") = "Test area" Then
			Reporter.ReportEvent micFail, "Login Failed","Browser: "&strBrowser&", URL: "&strURL&", User: "&strUser
			ExitTest
		End If
		
		Reporter.ReportEvent micDone, "Login sucessfully","Browser: "&strBrowser&", URL: "&strURL&", User: "&strUser
	
	Case "_ADMIN"
		strBrowser = "IE"
		strURL = "https://test.com/"
		strUser = "Test_Admin"
		strPassword = "Admin123"
		'Lauch Browser
		Func_Browser_Launch strBrowser, strURL
		
		'Input User and Password
		Func_WebEdit_SetText "","USER", strUser
		Func_WebEdit_SetText "","PASSWORD",strPassword
		
		'Click login
		Func_WebButton_Click "","Login"
		
		'If  Area list page not display, exittest
		If NOT Func_WebElement_GetText("","DIV","h1") = " Area list" Then
			Reporter.ReportEvent micFail, "Login_Admin Failed","Browser: "&strBrowser&", URL: "&strURL&", User: "&strUser
			ExitTest
		End If
		
		Reporter.ReportEvent micDone, "Login_Admin sucessfully","Browser: "&strBrowser&", URL: "&strURL&", User: "&strUser
		
	End Select
End Function


