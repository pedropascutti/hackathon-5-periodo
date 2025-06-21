package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.Disciplina;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DisciplinaRepository extends JpaRepository<Disciplina, Long> {
    List<Disciplina> findByProfessor_Usuario_Id(Long usuarioId);
    List<Disciplina> findAllByTurma_Alunos_Usuario_Id(Long usuarioId);
}