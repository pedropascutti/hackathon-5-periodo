package edu.unialfa.hackathon.dto;

import edu.unialfa.hackathon.model.Disciplina;

public record DisciplinaComProfessorDto(
        Long id,
        String nome,
        String nomeProfessor
) {
    public static DisciplinaComProfessorDto fromEntity(Disciplina d) {
        return new DisciplinaComProfessorDto(
                d.getId(),
                d.getNome(),
                d.getProfessor().getUsuario().getNome()
        );
    }
}

