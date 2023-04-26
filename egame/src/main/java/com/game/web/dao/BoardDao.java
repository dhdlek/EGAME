package com.game.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.game.web.model.Notice;
import com.game.web.model.Qna;
import com.game.web.model.Report;

@Repository("boardDao")
public interface BoardDao {
	// 공지사항 게시물 등록 
	public int noticeInsert(Notice notice);
	
	// 공지사항 게시물 수
	public long noticeListCount(Notice notice);
	
	// 공지사항 리스트
	public List<Notice> noticeList(Notice notice);
	
	// 공지사항 조회
	public Notice noticeSelect(long noticeSeq);
	
	// 공지사항 수정
	public int noticeUpdate(Notice notice);
	
	// 공지사항 삭제
	public int noticeDelete(long noticeSeq);
	
	// 문의 게시물 수
	public long qnaListCount(Qna qna);
	
	// 문의 리스트
	public List<Qna> qnaList(Qna qna);
	
	// 문의 게시물 등록
	public int qnaInsert(Qna qna);
	
	// 문의 조회
	public Qna qnaSelect(long qnaSeq);
	
	// 문의 답변 조회
	public Qna qnaReplySelect(long qnaSeq);
	
	// 문의 처리상태 업데이트
	public Qna qnaStatusUpdate(long qna);
	
	// 문의 답변 등록
	public int qnaReplyInsert(Qna qna);
	
	// 문의 수정
	public int qnaUpdate(Qna qna);
	
	// 문의 삭제시 답변 조회
	public int qnaAnswerCount(long qnaSeq);
	
	// 문의 삭제
	public int qnaDelete(long qnaSeq);
	
	// 신고 게시물 수
	public long reportListCount(Report report);
	
	// 신고 리스트
	public List<Report> reportList(Report report);
	
	// 신고 조회
	public Report reportSelect(long reportSeq);
	
	// 신고 처리상태 수정
	public int reportStatusUpdate(Report report);
	
	// 신고 등록
	public int reportInsert(Report report);
}
