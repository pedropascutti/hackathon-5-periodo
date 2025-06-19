package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.Turma;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TurmaRepository extends JpaRepository<Turma, Long> {
}