package com.game.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.game.web.model.Pay;
import com.game.web.model.UserPoint;

@Repository("payDao")
public interface PayDao {
	//결제 인서트
	public int payInsert(Pay pay);
	
	//보유게임 수
	public long libraryCount(String userId);
	
	//보유게임 리스트
	public List<Pay> libraryList(Pay pay);
	
	//친구 마이페이지 보유게임 전체 조회
	public List<Pay> libraryAllList(Pay pay);
	
	//보유게임 조회
	public Pay librarySelect(long paySeq);
	
	//보유게임 환불
	public int libraryRefund(Pay pay);
	
	//포인트 인서트
	public int userPointInsert(UserPoint userPoint);
	
	//포인트내역 수
	public long pointCount(String userId);
	
	//포인트내역 리스트
	public List<UserPoint> pointList(UserPoint userPoint);
	
	//포인트내역 조회
	public UserPoint pointSelect(long pointSeq);
}
