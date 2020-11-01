package com.madecontrol.projectpeopleandbusinessmonitoring.model.business;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.entity.Entity;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Taxes;

public class Racket extends BusinessEntity {

    private double racketMoney;

    public Racket(String title) {
        super(title);
    }

    private static double calculateIncome(double racketMoney, int quantityRackets) {
        return racketMoney * quantityRackets;
    }

    @Override
    public String getInfoByOwner(Entity owner) {
        String title = getTitle();
        int quantity = getQuantity();
        Currency incomeCurrency = getCurrencyIncome();
        double coefficient = getOwners().get(owner);

        String info;

        if(!isArrested()) {

            double incomeMoney = (getIncome() - getBribe()) * coefficient;
            int coefficientInt = (int) (coefficient * 100);

            info = String.format(INFO_NOT_ARRESTED_RACKET_BY_OWNER,
                    title, racketMoney, incomeCurrency, quantity, coefficientInt, incomeMoney, incomeCurrency);

        } else {

            info = String.format(INFO_ARRESTED_RACKET_BY_OWNER,
                    title, racketMoney, incomeCurrency, quantity);

        }

        return info;
    }

    @Override
    public double getTax() {
        return 1.0;
    }

    @Override
    public String getInfo() {
        return null;
    }

    public static class Builder {

        private final Racket racket;

        public Builder(String title) {
            racket = new Racket(title);
        }

        public Builder income(double racketMoney, Currency currency, int quantityRackets) {
            racket.setIncome(calculateIncome(racketMoney, quantityRackets));
            racket.setCurrencyIncome(currency);
            racket.setQuantity(quantityRackets);
            racket.racketMoney = racketMoney;
            return this;
        }

        public Builder owner(Entity owner, double coefficient) {
            racket.addOwner(owner, coefficient);
            return this;
        }

        public Builder giveBribe(double money, Currency currencyBribe, String description) {
            racket.addBribe(money, currencyBribe);
            return this;
        }

        public Builder arrested(boolean arrested) {
            racket.setArrested(arrested);
            return this;
        }

        public Racket build() {

            racket.getOwners().keySet()
                    .forEach(racket::registrationBusiness);

            return racket;
        }

    }

}
