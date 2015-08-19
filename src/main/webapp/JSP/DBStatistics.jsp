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
/**
 * hex를 rgb값으로 변환
 */
function hexToRgb(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}
function sortProperties(obj)
{
	 var A= [];
	    for(var p in obj){
	        if(obj.hasOwnProperty(p)) A.push([p, obj[p]]);
	    }
	    A.sort(function(a, b){
	        var a1= a[1], b1= b[1];
	        return b1-a1;
	    });
	    for(var i= 0, L= A.length; i<L; i++){
	        A[i]= A[i][0];
	    }
	    return A
}
var sortColors = function(colors) {
    var temp = {};
    for (var c = 0; c < colors.length; c++) {
        /* Get the hex value without hash symbol. */
        var hexcolor=colors[c];
        var hex = colors[c].substring(1);
         
        /* Get the RGB values to calculate the Hue. */
        var r = parseInt(hex.substring(0,2),16)/255;
        var g = parseInt(hex.substring(2,4),16)/255;
        var b = parseInt(hex.substring(4,6),16)/255;
 
        /* Getting the Max and Min values for Chroma. */
        var max = Math.max.apply(Math, [r,g,b]);
        var min = Math.min.apply(Math, [r,g,b]);
 
        /* Variables for HSV value of hex color. */
        var chr = max-min;
        var hue = 0;
        var val = max;
        var sat = 0;
 
        if (val > 0) {
            /* Calculate Saturation only if Value isn't 0. */
            sat = chr/val;
            if (sat > 0) {
                if (r == max) { 
                    hue = 60*(((g-min)-(b-min))/chr);
                    if (hue < 0) {hue += 360;}
                } else if (g == max) { 
                    hue = 120+60*(((b-min)-(r-min))/chr); 
                } else if (b == max) { 
                    hue = 240+60*(((r-min)-(g-min))/chr); 
                }
            }
        }
         
        /* Modifies existing objects by adding HSV values. */
        temp[hexcolor]=hue;
    //    colors[c].hue = hue;
     //   colors[c].sat = sat;
      //  colors[c].val = val;
    }
    var sorted_keys=sortProperties(temp);
    return sorted_keys;
    /* Sort by Hue. */
 //   return temp.sort(function(a,b){return a.hue - b.hue;});
}

function buildColorPalette(namesArray) {
	      //palette 요소들을 넣어줄 container 생성
     var container = document.createElement('DIV');
     container.className = 'b-palettewrap';
  
//색상 개수만큼 view돌려주기
	for(var i = 0; i < namesArray.length; i++) {
   //hex array값 추출
   var avg = namesArray[i];
   if(avg==namesArray[0]||avg==namesArray[namesArray.length-1])
   {
   avg=avg.replace(/\[|\]/g, '').replace(/ /g,'');
   }
   else
   {
   avg=avg.replace(/ /g,'');
   }
   namesArray[i]=avg;
}
   var sortnamesArray=sortColors(namesArray); 
	
   for(var i = 0; i < sortnamesArray.length; i++){
   var sortavg=sortnamesArray[i];
   //view에 rgb색상 뿌려주기 위해 다시 rgb로 변환
   var col=hexToRgb(sortavg);  
   //container에 담을 input element선언
   var el = document.createElement('input');
   el.type = 'text';
   el.className = 'b-palette';
   //색상값 background로 입히기
   el.style.backgroundColor = 'rgb('+col.r+','+col.g+','+col.b+')';
   //색 너비 설정
   el.style.width = Math.ceil(500 / sortnamesArray.length) + '%'; 
   //text value값 (avg=hex값, percent=hex percent)
   el.value = sortavg;
   el.addEventListener('click', function(e){ e.target.select(); }, false);
   container.appendChild(el); 
	}  
	  return { 
	    'el': container
	  };  
	} 
function printColor(colorArray){
     var targetEl = document.getElementById('drop');
    // targetEl.className='drag-waiting';
    //  var index = colorArray.indexOf(']');
     var namesArray = colorArray.split(",");
     targetEl.appendChild(buildColorPalette(namesArray).el);
     targetEl.appendChild(canvas); 
}
function init() {
	 var modelAttributeValue = '${output}';
	 printColor(modelAttributeValue);
}
window.addEventListener('load', init, false);
</script>
<body>

 <form name="writeForm"  method="POST" enctype="multipart/form-data">
  <h1>과자류 포장 색상 결과</h1>
   <div id="drop" class="drag-hover">
  </div>
  <%--    ${output} --%>
  <div>
    <input type="button" id= "reset" value="뒤로" onclick="location.href='home.jsp'">
  </div>
  </form>
</body>