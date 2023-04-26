package com.game.web.model;

import java.io.Serializable;

public class Report implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private long reportSeq;
	private long productSeq;
	private long reviewSeq;
	private String reportContent;
	private String reportRegDate;
	private String reportStatus;
	private String reportPr;
	private String reportTag;
	private String userId;
	
	private long startRow;
	private long endRow;
	
	private String searchPr;
	private String searchTag;
	private String searchValueOption;
	private String searchValue;
	
	public Report()
	{
		reportSeq = 0;
		productSeq = 0;
		reviewSeq = 0;
		reportContent = "";
		reportRegDate = "";
		reportStatus = "";
		reportPr = "";
		reportTag = "";
		userId = "";
		
		startRow = 0;
		endRow = 0;
		
		searchPr = "";
		searchTag = "";
		searchValueOption = "";
		searchValue ="";
	}

	public long getReportSeq() {
		return reportSeq;
	}

	public void setReportSeq(long reportSeq) {
		this.reportSeq = reportSeq;
	}

	public long getProductSeq() {
		return productSeq;
	}

	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
	}

	public long getReviewSeq() {
		return reviewSeq;
	}

	public void setReviewSeq(long reviewSeq) {
		this.reviewSeq = reviewSeq;
	}

	public String getReportContent() {
		return reportContent;
	}

	public void setReportContent(String reportContent) {
		this.reportContent = reportContent;
	}

	public String getReportRegDate() {
		return reportRegDate;
	}

	public void setReportRegDate(String reportRegDate) {
		this.reportRegDate = reportRegDate;
	}

	public String getReportStatus() {
		return reportStatus;
	}

	public void setReportStatus(String reportStatus) {
		this.reportStatus = reportStatus;
	}

	public String getReportPr() {
		return reportPr;
	}

	public void setReportPr(String reportPr) {
		this.reportPr = reportPr;
	}

	public String getReportTag() {
		return reportTag;
	}

	public void setReportTag(String reportTag) {
		this.reportTag = reportTag;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
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

	public String getSearchPr() {
		return searchPr;
	}

	public void setSearchPr(String searchPr) {
		this.searchPr = searchPr;
	}

	public String getSearchTag() {
		return searchTag;
	}

	public void setSearchTag(String searchTag) {
		this.searchTag = searchTag;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	public String getSearchValueOption() {
		return searchValueOption;
	}

	public void setSearchValueOption(String searchValueOption) {
		this.searchValueOption = searchValueOption;
	}
	
}
