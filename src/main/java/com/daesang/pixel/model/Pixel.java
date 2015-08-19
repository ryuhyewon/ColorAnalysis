package com.daesang.pixel.model;

import java.util.HashMap;

import org.springframework.web.multipart.MultipartFile;

public class Pixel {
	private String barcode;
	private String pixel;
	private HashMap<String, String> temp; 
	private MultipartFile file =null;
	private byte[] bytes;
	
	public String getBarcode(){
		return barcode;
	}
	public void setBarcode(String barcode){
		this.barcode=barcode;
	}
	public String getPixel(){
		return pixel;
	}
	public void setPixel(String pixels){
		this.pixel=pixel;
	}
	public HashMap<String, String> getCounter(){
		return temp;
	}
	public void setCounter(HashMap<String, String> temp){
		this.temp=temp;
	}
	
	public byte[] getBytes() {
		return bytes;
	}
	public void setBytes(byte[] bytes) {
		this.bytes = bytes;
	}
}

