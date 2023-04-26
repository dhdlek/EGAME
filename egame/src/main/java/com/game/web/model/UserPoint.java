package com.game.web.model;

import java.io.Serializable;

public class UserPoint implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long pointSeq;			//포인트 로그 번호
	private long paySeq;			//결제 번호
	private String userId;			//유저 아이디
	private long pointPos;			//유저 보유 포인트
	private long pointVar;			//변동 포인트
	private String pointStatus;		//포인트 스테이터스 (더하기,빼기)
	private String pointDate;		//포인트내역 날짜
	
	private long productSeq;		//상품 번호
	private String productName;		//상품 이름
	
	private long payPrice;			//결제 가격
	private String payStatus;		//결제 상태(1: 구매, 0: 환불)
	private String payMethod;		//결제 구분(c: 현금, p: 포인트)
	
	private long startRow;		//시작 rownum
	private long endRow;		//끝 rownum
	
	public UserPoint() {
		pointSeq = 0;
		paySeq = 0;
		userId = "";
		pointPos = 0;
		pointVar = 0;
		pointStatus = "";
		pointDate = "";
		
		productSeq = 0;
		productName = "";
		
		payPrice = 0;
		payStatus = "";
		payMethod = "";
		
		startRow = 0;
		endRow = 0;
	}

	
	public long getPointSeq() {
		return pointSeq;
	}

	public void setPointSeq(long pointSeq) {
		this.pointSeq = pointSeq;
	}

	public long getPaySeq() {
		return paySeq;
	}

	public void setPaySeq(long paySeq) {
		this.paySeq = paySeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getPointPos() {
		return pointPos;
	}

	public void setPointPos(long pointPos) {
		this.pointPos = pointPos;
	}

	public long getPointVar() {
		return pointVar;
	}

	public void setPointVar(long pointVar) {
		this.pointVar = pointVar;
	}

	public String getPointStatus() {
		return pointStatus;
	}

	public void setPointStatus(String pointStatus) {
		this.pointStatus = pointStatus;
	}

	public String getPointDate() {
		return pointDate;
	}

	public void setPointDate(String pointDate) {
		this.pointDate = pointDate;
	}

	public long getProductSeq() {
		return productSeq;
	}

	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}	
	
	public long getPayPrice() {
		return payPrice;
	}

	public void setPayPrice(long payPrice) {
		this.payPrice = payPrice;
	}

	public String getPayStatus() {
		return payStatus;
	}

	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}

	public String getPayMethod() {
		return payMethod;
	}

	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
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
}
