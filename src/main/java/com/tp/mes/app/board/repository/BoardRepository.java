package com.tp.mes.app.board.repository;

import com.tp.mes.app.board.model.BoardPost;
import java.util.List;
import java.util.Optional;

public interface BoardRepository {

  List<BoardPost> listPosts();

  Optional<BoardPost> findPost(long postId);
}
