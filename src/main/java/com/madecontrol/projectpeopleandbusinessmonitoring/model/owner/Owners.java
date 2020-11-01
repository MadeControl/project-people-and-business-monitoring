package com.madecontrol.projectpeopleandbusinessmonitoring.model.owner;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.entity.Entity;
import java.util.Map;

public final class Owners {

    private Owners() {
    }

    public static void addOwner(Map<Entity, Double> owners, Entity owner, double coefficient) {

        double sumCoefficients = owners.values().stream()
                .mapToDouble(v -> v)
                .sum();

        if (sumCoefficients + coefficient <= 1.0) {
            owners.put(owner, coefficient);

        } else {

            int coefficientInt = (int)(coefficient * 100);
            String exceptionInfo = String.format(
                    "Coefficient '%d'%% of owner '%s' is so big. Sum of all coefficients can't be more than 100%%.",
                    coefficientInt, owner.getName());

            throw new IllegalArgumentException(exceptionInfo);
        }
    }
}
