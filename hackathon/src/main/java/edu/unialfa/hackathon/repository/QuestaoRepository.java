package edu.unialfa.hackathon.repository;

import edu.unialfa.hackathon.model.Questao;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuestaoRepository extends JpaRepository<Questao, Long> {
}
