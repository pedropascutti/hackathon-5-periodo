package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.Professor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProfessorRepository extends JpaRepository<Professor, Long> {
    boolean existsByUsuarioId(Long usuarioId);
    Optional<Professor> findByUsuarioId(Long usuarioId);
}
