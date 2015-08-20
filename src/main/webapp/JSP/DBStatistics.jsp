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
/**
 * 색상값들 hue에 따라 sort시키는 클래스(색상별 분포 보기 위함) 
 * @param {colors} pixel value 배열
 */
var sortColors = function(colors) {
    var temp = {},
        rgbArray=[];
    for (var c = 0; c < colors.length; c++) {
        /* hash symbol없이 hex value 추출 */
        var hexcolor=colors[c];
        var hex = colors[c].substring(1);
         
        /* Hue계산하기 위해 RGB 추출. */
        var r = parseInt(hex.substring(0,2),16)/255;
        var g = parseInt(hex.substring(2,4),16)/255;
        var b = parseInt(hex.substring(4,6),16)/255;
        
        var rgb=[r,g,b];
        rgbArray.push(rgb);
 
        /* 채도를 위해 Max,Min값 추출. */
        var max = Math.max.apply(Math, rgb);
        var min = Math.min.apply(Math, rgb);
 
        /* hex color의 HSV 값에 대한 변수들. */
        var chr = max-min;
        var hue = 0;
        var val = max;
        var sat = 0;
 
        if (val > 0) {
            /* value가 0이 아닐때만 saturation계산 */
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
         
        /* HSV값에 따라 존재하는 객체 수정하기 (or sat, val에 따라 sort도 가능)*/
        temp[hexcolor]=hue;
    }
    /* Hue값에 따라 sort */
    var sorted_keys=sortProperties(temp);
    return sorted_keys;
}
function compare(averageColors){
	 // 평균 색상배열들 간에 색상 비교하기
    while(averageColors.length > 0) {
      var baseCol = averageColors.shift(), //첫번째 배열값  짜르기
          avgColor = baseCol,//avg에 값 가져옴
          /** 배열 길이 counting하기 위한 변수*/
          k = 0,
          /** 해당 픽셀의 count*/
          count=0;
      
      //첫번째 배열값, 다른 배열값들과 비교해주기 
      while(true) {
        if(averageColors.length > k) {
          var secondCol = averageColors[k];
          //유사한 색상일 때 두 값 평균구하여 하나의 색상으로 처리
          if(areSimilarColors(baseCol, secondCol)){
          	 avgColor = getAverageColor(avgColor, averageColors.splice(k,1)[0]); //k위치에 1개 잘라내기
          	 // while(averageColors.length > 0)동안 계속 count
          	 totalcount++;
          	 //avgColor가 다른 배열값들과 유사한 개수만큼 count
          	 count++;                   
          } else 
            k++;
          
        }//배열 한번 훓기
        else
      	  break; 
      }
      //avgColor값, uniqueColors array에 새로 담기
      uniqueColors.push(avgColor);
      //rgb값 hex로 변환하여 count와 Object객체로 헤쉬 매핑
      var avg=rgbToHex(avgColor);
      temp[avg]=count
    }
}
/**
 * 비슷한 색상인지 비교해주는 클래스
 * @param {col1, col2} 두 색상간의 rgb비교
 */
function areSimilarColors(col1, col2) {
	  var delta = 100;
	  if( 
	      (Math.abs(col2[0] - col1[0]) <= delta) && 
	      (Math.abs(col2[1] - col1[1]) <= delta) && 
	      (Math.abs(col2[2] - col1[2]) <= delta) 
	    )
	    return true;
	  else
	    return false;
	}
 /**
  * 색상 배열 입혀주는 container 클래스
  * @param {namesArray} pixel value 배열
  */
function buildColorPalette(namesArray) {
	 //palette 요소들을 넣어줄 container 생성
     var container = document.createElement('DIV');
     container.className = 'b-palettewrap';
  
//색상 개수만큼 view돌려주기
	for(var i = 0; i < namesArray.length; i++) {
   //hex array값 추출
   var avg = namesArray[i];
   //객체를 배열로 변환하는 과정에서 배열 내 필요없는 문자들 띄어쓰기,[] 제거
   if(avg==namesArray[0]||avg==namesArray[namesArray.length-1])
   {
   avg=avg.replace(/\[|\]/g, '').replace(/ /g,'');
   }
   else
   {
   avg=avg.replace(/ /g,'');
   }
   //namesArray에 다시 매핑
   namesArray[i]=avg;
}
   //색상값들 hue에 따라 sort시킴(색상별 분포 보기 위함)
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
   //text value값 (sortavg=hex값)
   el.value = sortavg;
   el.addEventListener('click', function(e){ e.target.select(); }, false);
   container.appendChild(el); 
	}  
	  return { 
	    'el': container
	  };  
	} 
/**
 * 비슷한 색상인지 비교해주는 클래스
 * @param {colorArray} pixel value 객체
 */
function printColor(colorArray){
	 //drop영역에 결과값 뿌려주기
     var targetEl = document.getElementById('drop');
     //객체 배열로 변환
     var namesArray = colorArray.split(",");
     targetEl.appendChild(buildColorPalette(namesArray).el);
     targetEl.appendChild(canvas); 
}
/**
 * controller에서 받은 pixel value값 받아와서 뿌려주기(초기화 클래스)
 */
function init() {
	 var modelAttributeValue = '${output}';
	 printColor(modelAttributeValue);
}
window.addEventListener('load', init, false);
</script>
<head>
<script type="text/javascript">
window.onload = function () {
	    var color="#2F4F4F";
		CanvasJS.addColorSet("greenShades",
	                [//colorSet Array
	                color
	  /*               "#008080",
	                "#2E8B57",
	                "#3CB371",
	                "#90EE90"  */               
	                ]);
		var chart = new CanvasJS.Chart("chartContainer",
		{
		colorSet: "greenShades",
		title:{
			text: "상위 색상"
		},
		exportFileName: "Pie Chart",
		exportEnabled: true,
                animationEnabled: true,
		legend:{
			verticalAlign: "bottom",
			horizontalAlign: "center"
		},
		data: [
		{       
			type: "pie",
			showInLegend: true,
			toolTipContent: "{legendText}: <strong>{y}%</strong>",
			indexLabel: "{label} {y}%",
			dataPoints: [
				{  y: 35, legendText: "", exploded: true, label: "" },
				{  y: 20, legendText: "", label: "" },
				{  y: 18, legendText: "", label: "" },
				{  y: 15, legendText: "", label: ""},
				{  y: 5, legendText: "", label: "" },
				{  y: 7, legendText: "", label: ""}
			]
	}
	]

	});
	chart.render();
}
</script>
<script type="text/javascript" src="js/canvasjs.min.js"></script> 
<body>

 <form name="writeForm"  method="POST" enctype="multipart/form-data">
  <h1>과자류 포장 색상 결과</h1>
   <div id="drop" class="drag-hover">
  </div>
     <div id="chartContainer" style="height: 300px; width: 100%;"></div>  
  <div>
    <input type="button" id= "reset" value="뒤로" onclick="location.href='home.jsp'">
  </div>
  </form>
</body>