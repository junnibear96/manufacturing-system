package com.tp.mes.app.board.service;

import com.tp.mes.app.board.model.BoardPost;
import java.util.List;
import java.util.Optional;

public interface BoardService {

  List<BoardPost> listPosts();

  Optional<BoardPost> findPost(long postId);
}
