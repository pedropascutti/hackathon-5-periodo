package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.Professor;
import edu.unialfa.hackathon.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProfessorRepository extends JpaRepository<Professor, Long> {
    boolean existsByUsuarioId(Long usuarioId);
    Optional<Professor> findByUsuarioId(Long usuarioId);
    Optional<Professor> findByUsuario(Usuario usuario);
}
