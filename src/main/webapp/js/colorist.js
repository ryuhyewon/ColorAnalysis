var file,
uniqueColors = [],
tcount=[],
temp = {};

/**
 * 20X20 영역의 색상의 평균을 구해주는 클래스이다.
 * @return 평균 rgb array 
 */
function averageColorFor(data) {
  var result = [0, 0, 0],
      total_pixels = data.length / 4,
      count=0;
 //픽셀 더하기 
  for (var i = 0; i <= total_pixels; i += 4) {
    result[0] += data[i];
    result[1] += data[i + 1];
    result[2] += data[i + 2];
  }
  
  //평균 구하기,255이상이면 255로 return
    for (var i = 0; i < 3; i++) {
    result[i] = Math.round(result[i] / total_pixels) * 4;
    result[i] = (result[i] > 255) ? 255 : result[i];
  }
  return result ;
}


/**
 * 비슷한 색상인지 비교해주는 클래스
 * @param {col1, col2} 두 색상간의 rgb비교
 */
function areSimilarColors(col1, col2) {
	  var delta = 50;
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
 * 두 색상의 평균을 구해주는 클래스이다.(두 색상값을 areSimilarColors클래스로 비교한 후 유사한 색상일 때 두 색상간의 평균을 구하여 하나의 색상으로 return한다)
 * @return {array} average of col1, col2
 */
function getAverageColor(col1, col2) {
  var r = Math.round((col1[0] + col2[0]) / 2);
  var g = Math.round((col1[1] + col2[1]) / 2);
  var b = Math.round((col1[2] + col2[2]) / 2);
  return [r,g,b];
}

/**
 * rgb값을 hex로 변환
 */
function rgbToHex(array){
	var hex = [];
	for (var i = 0; i < 3; i++){
		var bit = (array[i] - 0).toString(16);
		hex.push((bit.length == 1) ? '0' + bit : bit);
	}
	return '#' + hex.join('');
}

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

/**
 * 색상 분포 count 내림차순으로 정렬 
 * @param {obj} Object객체 key: hex값 value:count
 * @return {A} key값 array만 return
 */
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
 * container에 색상 파레트 뿌려주기
 * @param {colorsArray} hex값 array
 * @param {countHashmap} Object객체 key: hex값 value:count
 * @return {el} 색상파레트 container
 */
function buildColorPalette(colorsArray,countHashmap) {
  var prevCol = [0,0,0],
      uniqueColors = 0,
      //palette 요소들을 넣어줄 container 생성
      container = document.createElement('DIV');
      container.className = 'b-palette-wrap';
      
      //전체 픽셀 count 받아오기
      var totalcounts=countHashmap["totalcount"];
    
 //색상 개수만큼 view돌려주기
	for(var i = 0; i < colorsArray.length; i++) {
    //hex array값 추출
    var avg = colorsArray[i];
    //count값 추출
    var counts= countHashmap[avg];
    //전체 count분의 count값으로  소수점 2자리까지 변환
    percent=(counts/totalcounts*100).toFixed(2);
    //percent 새로운 배열에 담기 
    tcount.push(percent);
    
    //view에 rgb색상 뿌려주기 위해 다시 rgb로 변환
    var col=hexToRgb(avg);
    //container에 담을 input element선언
    var el = document.createElement('input');
    el.type = 'text';
    el.className = 'b-palette';
    //색상값 background로 입히기
    el.style.backgroundColor = 'rgb('+col.r+','+col.g+','+col.b+')';
    //색 너비 설정
    el.style.width = Math.ceil(120 / colorsArray.length) + '%'; 
    //text value값 (avg=hex값, percent=hex percent)
    el.value = avg+ " "+percent+"%";
    el.addEventListener('click', function(e){ e.target.select(); }, false);
    container.appendChild(el);
  }
  //percent hidden value에 매핑
  document.getElementById('temp').value = tcount;
  return { 
    'el': container
  };
}

/**
 * 이미자가 업로드되었을 때 이미지를 분석하는 클래스이다
 * @param {colorsArray} hex값 array
 * @param {countHashmap} Object객체 key: hex값 value:count
 * @return {el} 색상파레트 container
 */
function handleDragDropEvent(e) {
	  if (e.preventDefault) e.preventDefault();
	  
	  //파일 읽어오기
	  var files = e.target.files;
	  file = files[0];
	  
	  //drop영역에 결과 쁘려주기
	  var targetEl = document.getElementById('drop');
	      targetEl.className='drag-waiting';
	      targetEl.innerHTML = '색상 분석중...';
	      
	      targetEl.className =targetEl.className.replace('drag-hover');

	      //여러 파일일 떄 사용
	      // files.forEach(function(file){
	      
	        image = new Image();
	        image.onload = function(){
	          // canvas container
	          targetEl.innerHTML = '';
	          targetEl.className = '';
	          
	          var canvas = document.createElement('canvas');
	          var ctx = canvas.getContext('2d');

	          // image 반으로짜르기
	          canvas.width = image.width / 2 >> 0;
	          canvas.height = image.height / 2 >> 0;
	          ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
	       
	          var averageColors = [],
	              counts=[],
	              //20셀씩 짤라서 픽셀값 받아오기위함 
	              rows = 20,
	              cells = 20,
	              cellWidth = (canvas.width / cells) >> 0,
	              cellHeight = (canvas.height / rows) >> 0;
	             

	          // image slice로 짜르기
	          for(var i = 0; i < rows; i++) {
	            for(var j = 0; j < cells; j++) {
	              //20셀씩 data담기 getImageData(left, top, width, height)
	              var colorArray = ctx.getImageData(cellWidth * j, cellHeight * i, cellWidth, cellHeight);
	              var pix = colorArray.data;
	              //흰색 제거하기 위해 사용하는 객체
	              var newColor = {a:0};
	              
	              for(var k=0, n=pix.length; k<n; k+=4)
	            	  {
	            	    var r = pix[k],
	                    g = pix[k+1],
	                    b = pix[k+2];
	            	    
	            	//white색상 ㅁalpha값 0으로 변환
	                if(r >= 230 && g >= 230 && b >= 230) { 
	                	pix[k+3] = newColor.a;
	                }
	                
	                //alpha 0인 값은 제외하여 픽셀 담기
	                if(pix[k+3]!=0) {
	                    var averageColor = averageColorFor(pix);
	                    averageColors.push(averageColor);  
	               }
	              }
	              
	             }
	          }
	          /** 대표 색상 중 totalcount*/
	         var  totalcount=0;
	         
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
	          /**
	           *count값 내림차순으로 sort, hidden value로 픽셀값 넣기
	           *@param {temp} object 객체 key:hex값, value:count
	           * @param {sorted_keys} count값에 따라 내림차순한 hex색상 키값
	           */
	         var sorted_keys=sortProperties(temp);
	         document.getElementById('pixel').value = sorted_keys;
	         
	         temp["totalcount"]=totalcount;
	         //drop 영역에 색상 파레트 더하기
	          targetEl.appendChild(buildColorPalette(sorted_keys,temp).el);
	          targetEl.appendChild(canvas);  
	        };        
	        /**
	         * 이미지 출력
	         * @constructor 
	         */
	        var reader = new FileReader();
	        reader.onloadend = function(e) { image.src = e.target.result; };
	        reader.readAsDataURL(file);
	 
	  return;
	}   
