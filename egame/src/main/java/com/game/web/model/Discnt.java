package com.game.web.model;

import java.io.Serializable;

public class Discnt implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long discntSeq;				//할인번호
	private long productSeq;			//상품 번호
	private long discntRate;			//할인 율
	private String discntStartDate;		//할인 시작 날짜
	private String discntEndDate;		//할인 종료 날짜
	private char discntStatus;			//할인 적용 여부 Y: 할인 적용중, N: 할인 미적용중
	
	private String productName;			//상품 이름
	private String searchValue;			//이름 검색 밸류
	private String dateSearch;			//날짜검색 
	
	private long startRow;				//상품페이징 시작번호
	private long endRow;				//상품 페이징 끝 번호
	private long curPage;				//현재 페이지	
	
	public Discnt()
	{
		discntSeq = 0;
		productSeq = 0;
		discntRate = 0;
		discntStartDate = "";
		discntEndDate = "";
		discntStatus = 'N';
		
		productName = "";
		searchValue="";
		dateSearch ="";
		
		startRow = 0;
		endRow = 0;
		curPage = 1;
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




	public String getSearchValue() {
		return searchValue;
	}




	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}




	public String getDateSearch() {
		return dateSearch;
	}




	public void setDateSearch(String dateSearch) {
		this.dateSearch = dateSearch;
	}




	public String getProductName() {
		return productName;
	}




	public void setProductName(String productName) {
		this.productName = productName;
	}




	public char getDiscntStatus() {
		return discntStatus;
	}




	public void setDiscntStatus(char discntStatus) {
		this.discntStatus = discntStatus;
	}




	public String getDiscntStartDate() {
		return discntStartDate;
	}




	public void setDiscntStartDate(String discntStartDate) {
		this.discntStartDate = discntStartDate;
	}




	public String getDiscntEndDate() {
		return discntEndDate;
	}




	public void setDiscntEndDate(String discntEndDate) {
		this.discntEndDate = discntEndDate;
	}




	public long getDiscntSeq() {
		return discntSeq;
	}


	public void setDiscntSeq(long discntSeq) {
		this.discntSeq = discntSeq;
	}


	public long getProductSeq() {
		return productSeq;
	}


	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
	}


	public long getDiscntRate() {
		return discntRate;
	}


	public void setDiscntRate(long discntRate) {
		this.discntRate = discntRate;
	}


	
	
}
