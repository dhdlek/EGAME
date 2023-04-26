package com.game.web.model;

import java.io.Serializable;

public class Qna implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private long qnaSeq;
	private String userId;
	private String qnaTitle;
	private String qnaContent;
	private String qnaRegDate;
	private long qnaParent;
	private String qnaStatus;
	
	private long startRow;
	private long endRow;
	
	private String searchValue;
	
	public Qna()
	{
		qnaSeq = 0;
		userId = "";
		qnaTitle = "";
		qnaContent = "";
		qnaRegDate = "";
		qnaParent = 0;
		qnaStatus = "N";
		
		startRow = 0;
		endRow = 0;
		
		searchValue = "";
	}

	public long getQnaSeq() {
		return qnaSeq;
	}

	public void setQnaSeq(long qnaSeq) {
		this.qnaSeq = qnaSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getQnaTitle() {
		return qnaTitle;
	}

	public void setQnaTitle(String qnaTitle) {
		this.qnaTitle = qnaTitle;
	}

	public String getQnaContent() {
		return qnaContent;
	}

	public void setQnaContent(String qnaContent) {
		this.qnaContent = qnaContent;
	}

	public String getQnaRegDate() {
		return qnaRegDate;
	}

	public void setQnaRegDate(String qnaRegDate) {
		this.qnaRegDate = qnaRegDate;
	}

	public long getQnaParent() {
		return qnaParent;
	}

	public void setQnaParent(long qnaParent) {
		this.qnaParent = qnaParent;
	}

	public String getQnaStatus() {
		return qnaStatus;
	}

	public void setQnaStatus(String qnaStatus) {
		this.qnaStatus = qnaStatus;
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

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}
	
}
