package com.game.web.model;

import java.io.Serializable;

public class Notice implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private long noticeSeq;
	private String adminId;
	private String noticeTitle;
	private String noticeContent;
	private String noticeRegDate;
	
	private long startRow;
	private long endRow;
	
	private String searchValue;
	
	public Notice()
	{
		noticeSeq = 0;
		adminId = "";
		noticeTitle = "";
		noticeContent = "";
		noticeRegDate = "";
		
		startRow = 0;
		endRow = 0;
		
		searchValue = "";
	}

	public long getNoticeSeq() {
		return noticeSeq;
	}

	public void setNoticeSeq(long noticeSeq) {
		this.noticeSeq = noticeSeq;
	}

	public String getAdminId() {
		return adminId;
	}

	public void setAdminId(String adminId) {
		this.adminId = adminId;
	}

	public String getNoticeTitle() {
		return noticeTitle;
	}

	public void setNoticeTitle(String noticeTitle) {
		this.noticeTitle = noticeTitle;
	}

	public String getNoticeContent() {
		return noticeContent;
	}

	public void setNoticeContent(String noticeContent) {
		this.noticeContent = noticeContent;
	}

	public String getNoticeRegDate() {
		return noticeRegDate;
	}

	public void setNoticeRegDate(String noticeRegDate) {
		this.noticeRegDate = noticeRegDate;
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
