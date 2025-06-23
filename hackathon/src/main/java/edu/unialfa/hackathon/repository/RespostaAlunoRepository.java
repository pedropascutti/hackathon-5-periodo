package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.RespostaAluno;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RespostaAlunoRepository extends JpaRepository<RespostaAluno, Long> {
    List<RespostaAluno> findByAlunoId(Long alunoId);
    List<RespostaAluno> findByProvaId(Long provaId);
}
