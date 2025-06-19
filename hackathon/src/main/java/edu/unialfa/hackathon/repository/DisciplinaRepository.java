package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.Disciplina;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DisciplinaRepository extends JpaRepository<Disciplina, Long> {
}