package com.daesang.pixel.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileUploadException;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;



/** 
 * DB controller 클래스입니다.  
 *  작성일 : ${date}
 * @author ryuhyewon
 */ 

@Controller
public class HomeController {
	@Autowired
	private SqlSession sqlSession;
	String redirectUrl = "http://localhost:8080/pixel/";
	private ArrayList<Object> output;

	
	@RequestMapping(value ="/DBSave",  method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ModelAndView  home(
			@RequestParam(value = "combo_nm") String type, 
			@RequestParam(value = "pixel") String[] pixel, 
			@RequestParam(value = "temp")  String[] temp, 
			DefaultMultipartHttpServletRequest request,
			HttpServletResponse httpServletResponse,
            Model model) 
			throws SQLException, IOException, FileUploadException{
		
		@SuppressWarnings("unused")
		byte[] bytes=null; 
		
	     /** @type {HashMap<String, Object>} */ 
		 HashMap<String, Object> input = new HashMap<String, Object>();

		 //픽셀 개수만큼 db input 현재 대표색상 1개 pixel만 추출
	//	 for(int i=0;i<pixel.length;i++){
			 //입력 바코드
			 input.put("type", type);
			 
			 //제품 이미지 
			 MultipartFile file = request.getFile("file");
			 bytes=file.getBytes();
	 		 input.put("image", bytes);
	
	 		 //hex 색상값 
			 String pixelEach=pixel[0];
			 input.put("pixel",pixelEach);
			 
			 //색상 percent값
			 String counter= temp[0];
			 input.put("counter", counter);
			 
			 //mybatis mapper로 insert
			 this.sqlSession.insert("userControlMapper.Insert", input);
	//		  }  
			 //기존 view 갱신
		 return new ModelAndView("redirect:" + redirectUrl);
	}
    
	
	 @RequestMapping(value ="/DBSave",params="Select", method = RequestMethod.POST)
	 public ModelAndView insert(HttpServletRequest request,
			 Model model){
		 //db pixel data 불러오기
		 List<HashMap<String, String>> outputs= sqlSession.selectList("userControlMapper.Select"); 
		 this.output = new ArrayList<Object>(); 
		 
		 //value값만 불러오기
		 for(HashMap<String,String> row : outputs){
			 output.add(row.get("pixel"));			 
			}
		 //model에 값 전달
		 model.addAttribute("output",output);
		 //DBStatistics.jsp로 return
		 return new ModelAndView("DBStatistics", "model", output);
		}
}
