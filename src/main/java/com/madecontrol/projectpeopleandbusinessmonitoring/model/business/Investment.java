package com.madecontrol.projectpeopleandbusinessmonitoring.model.business;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.entity.Entity;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Taxes;

public class Investment extends BusinessEntity {

    private double incomeCoefficient;

    public Investment(String title) {
        super(title);
    }

    private static double calculateIncome(double investMoney, double incomeCoefficient) {
        return investMoney * incomeCoefficient;
    }

    @Override
    public String getInfo() {
        return null;
    }

    @Override
    public String getInfoByOwner(Entity owner) {
        String title = getTitle();
        int investCoefficient = (int)(incomeCoefficient * 100);
        double coefficient = getOwners().get(owner);
        double investedMoney = getPrice() * coefficient;
        Currency investCurrency = getCurrencyPrice();

        String info;

        if(!isArrested()) {

            boolean controlledTaxes = isControlledTaxes();

            double incomeMoney = (getIncome() * (controlledTaxes ? Taxes.getBusinessTax() : 1.0) - getBribe()) * coefficient;

            Currency incomeCurrency = getCurrencyIncome();

            int coefficientInt = (int) (coefficient * 100);

            info = String.format(INFO_NOT_ARRESTED_INVESTMENT_BY_OWNER,
                    title, investCoefficient, coefficientInt,
                    controlledTaxes, investedMoney, investCurrency, incomeMoney, incomeCurrency);

        } else {

            info = String.format(INFO_ARRESTED_INVESTMENT_BY_OWNER,
                    title, investCoefficient, investedMoney, investCurrency);

        }

        return info;
    }

    @Override
    public double getTax() {
        return Taxes.getInvestmentTax();
    }

    public static class Builder {

        private final Investment investment;

        public Builder(String title) {
            investment = new Investment(title);
        }

        public Builder invest(double investMoney, Currency currency, double incomeCoefficient) {
            investment.incomeCoefficient = incomeCoefficient;
            investment.setPrice(investMoney);
            investment.setCurrencyPrice(currency);
            investment.setIncome(calculateIncome(investMoney, incomeCoefficient));
            investment.setCurrencyIncome(currency);
            return this;
        }

        public Builder owner(Entity owner, double coefficient) {
            investment.addOwner(owner, coefficient);
            return this;
        }

        public Builder giveBribe(double money, Currency currencyBribe, String description) {
            investment.addBribe(money, currencyBribe);
            return this;
        }

        public Builder controlledTaxes(boolean controlledTaxes) {
            investment.setControlledTaxes(controlledTaxes);
            return this;
        }

        public Builder arrested(boolean arrested) {
            investment.setArrested(arrested);
            return this;
        }

        public Investment build() {

            investment.getOwners().keySet()
                    .forEach(investment::registrationBusiness);

            return investment;
        }

    }

}
