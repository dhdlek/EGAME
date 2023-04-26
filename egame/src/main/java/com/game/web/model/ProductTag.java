package com.game.web.model;

import java.io.Serializable;

public class ProductTag implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long productSeq;		//상품번호
	private String tagNum;			//태그번호

	public ProductTag()
	{
		productSeq = 0;
		tagNum = "";
	}
	
	
	public long getProductSeq() {
		return productSeq;
	}
	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
	}
	public String getTagNum() {
		return tagNum;
	}
	public void setTagNum(String tagNum) {
		this.tagNum = tagNum;
	}
	

}
