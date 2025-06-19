package edu.unialfa.hackathon.service;

import edu.unialfa.hackathon.model.Disciplina;
import edu.unialfa.hackathon.repository.DisciplinaRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class DisciplinaService {

    private final DisciplinaRepository disciplinaRepository;

    public List<Disciplina> listarTodas() {
        return disciplinaRepository.findAll();
    }

    public Disciplina buscarPorId(Long id) {
        return disciplinaRepository.findById(id).orElse(null);
    }

    @Transactional
    public void salvar(Disciplina disciplina) {
        disciplinaRepository.save(disciplina);
    }

    public void deletarPorId(Long id) {
        disciplinaRepository.deleteById(id);
    }
}