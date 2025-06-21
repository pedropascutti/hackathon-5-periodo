package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.Prova;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProvaRepository extends JpaRepository<Prova, Long> {
    List<Prova> findByDisciplina_Professor_Usuario_Id(Long usuarioId);
}
