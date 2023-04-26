package com.game.web.model;

import java.io.Serializable;
import java.util.List;


//검색쿼리 모델
public class ProductSearch implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String productName;			//상품 검색이름
	private String discntCheck;				//할인품목 조건 선택여부    Y:할인품목만 보기 N:전체보기
	private long minPrice;				//상품가격 최소값
	private long maxPrice;				//상품가격 최댓값
	private String tagParentNum;		//상품 대분류태그번호 (0100,0200,0300,0400)
	private List<String> tagNum;		//상품태그번호 배열
	private String orderValue;			//상품정렬방법
	private String productStatus;		//상품 스테이터스
	
	private long startRow;				//상품페이징 시작번호
	private long endRow;				//상품 페이징 끝 번호
	private long curPage;				//현재 페이지	
	
	public ProductSearch()
	{
		productName = "";
		discntCheck = "N";
		minPrice = 0;
		maxPrice = 0;
		tagParentNum = "";
		tagNum = null;
		orderValue = "";
		productStatus = "";
		
		startRow = 0;
		endRow = 0;
		curPage = 1;
	}

	
	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getDiscntCheck() {
		return discntCheck;
	}

	public void setDiscntCheck(String discntCheck) {
		this.discntCheck = discntCheck;
	}

	public long getMinPrice() {
		return minPrice;
	}

	public void setMinPrice(long minPrice) {
		this.minPrice = minPrice;
	}

	public long getMaxPrice() {
		return maxPrice;
	}

	public void setMaxPrice(long maxPrice) {
		this.maxPrice = maxPrice;
	}

	public String getTagParentNum() {
		return tagParentNum;
	}

	public void setTagParentNum(String tagParentNum) {
		this.tagParentNum = tagParentNum;
	}

	public List<String> getTagNum() {
		return tagNum;
	}

	public void setTagNum(List<String> tagNum) {
		this.tagNum = tagNum;
	}

	public String getOrderValue() {
		return orderValue;
	}

	public void setOrderValue(String orderValue) {
		this.orderValue = orderValue;
	}

	public String getProductStatus() {
		return productStatus;
	}

	public void setProductStatus(String productStatus) {
		this.productStatus = productStatus;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}

	public long getCurPage() {
		return curPage;
	}

	public void setCurPage(long curPage) {
		this.curPage = curPage;
	}
}
