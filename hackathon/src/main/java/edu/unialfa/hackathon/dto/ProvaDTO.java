package edu.unialfa.hackathon.dto;

import edu.unialfa.hackathon.model.Prova;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;

@Data
@AllArgsConstructor
public class ProvaDTO {
    private Long id;
    private LocalDate data;
    private String nomeDisciplina;

    public static ProvaDTO fromEntity(Prova prova) {
        return new ProvaDTO(
                prova.getId(),
                prova.getData(),
                prova.getDisciplina().getNome()
        );
    }
}
