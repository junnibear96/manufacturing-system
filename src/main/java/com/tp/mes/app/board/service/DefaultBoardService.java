package com.tp.mes.app.board.service;

import com.tp.mes.app.board.model.BoardPost;
import com.tp.mes.app.board.repository.BoardRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;

@Service
public class DefaultBoardService implements BoardService {

  private final BoardRepository repository;

  public DefaultBoardService(BoardRepository repository) {
    this.repository = repository;
  }

  @Override
  public List<BoardPost> listPosts() {
    return repository.listPosts();
  }

  @Override
  public Optional<BoardPost> findPost(long postId) {
    return repository.findPost(postId);
  }
}
