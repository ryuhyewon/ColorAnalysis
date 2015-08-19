<%@ page contentType="text/html;charset=utf-8" import="java.sql.*" pageEncoding="utf-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="robots" content="follow"> 
	<meta name="language" content="ko">
  <title>대상 : villaapp </title>
	<link rel="stylesheet" href="css/styles.css" type="text/css" media="screen" title="no title" charset="utf-8"> 
</head>
<script> 
function change() {
	var combo = document.writeForm.combo;
	var txt = document.writeForm.combo_nm;
	var comboVal = combo.value;
	
	for( var i=0; i<combo.options.length; i++ ) {
	if( combo.options[i].value == comboVal ) {
	combo.options[i].checked = true;
	txt.value= combo.options[i].value;
	}
	}
	}
function checking()
{
 	 	if(document.writeForm.barcode.value == "")
 	 	 {alert("바코드를 입력하세요")
 	 	  return false;}
 	 	else 
 	 		{document.writeForm.submit()} 
}
function init() {
	//파일 업로드됐을 때 event change발생
   document.getElementById('file').addEventListener('change', handleDragDropEvent, false);
   var txt = document.writeForm.combo_nm;
   txt.value=combo.option[0].value;
   
}

window.addEventListener('load', init, false);
</script>
<body>
 <form name="writeForm"  action="DBSave" method="POST" enctype="multipart/form-data">
  <h1>포장제품 사진 픽셀 추출</h1>
  Files: <input type="file" name ="file" id="file"  multiple/><input type="button" id= "reset" value="초기화" onclick="location.href='home.jsp'">
   <div id="drop" class="drag-waiting">
  </div>
  <input type="hidden" name ="pixel" id="pixel" value="" />
  <input type="hidden" name ="temp" id="temp" value="" />
  <div>
  <h5>
  식품 유형을 선택해주세요 : 
<SELECT name="combo" onChange="change();">
<OPTION selected="selected" value="snack">과자류</OPTION>
<OPTION value="beverage">음료류</OPTION>
<OPTION value="noodle">라면류</OPTION>
</SELECT>
<input type="text" name="combo_nm" >
 <input type="submit"  value="DB 전송" name="Save" onClick="javascript:checking()">
 <input type="submit" value="통 계"  name="Select" /> </h5>
  </div>
  </form>
  <script src="js/jquery.1.9.1.min.js" type="text/javascript"></script>
<script src="js/colorist.js" type="text/javascript" charset="utf-8"></script>
</body>