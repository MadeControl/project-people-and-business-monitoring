package com.madecontrol.projectpeopleandbusinessmonitoring.model.money;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Stream;

public class MoneyStorageImpl implements MoneyStorage {

    private Map<Currency, Double> storage;

    public MoneyStorageImpl() {
        this.storage = new LinkedHashMap<>();

        Stream.of(Currency.values())
                .forEach((currency) -> storage.put(currency, 0.0));
    }

    @Override
    public void addMoney(double money, Currency currency) {
        double oldMoney = storage.get(currency);
        storage.put(currency, oldMoney + money);
    }

    @Override
    public String getInfo() {
        StringBuilder info = new StringBuilder();

        storage.entrySet().stream()
                .filter((entry) -> entry.getValue() != 0)
                .forEach((entry) -> info.append(String.format(INFO_MONEY, entry.getValue(), entry.getKey()))
                                        .append(System.lineSeparator()));

        // if money storage has zero money, it is necessary to add string follow format: * 0.00 USD
        if(info.toString().equals("")) {
            info.append(String.format(INFO_MONEY, 0.0, Currency.USD))
                    .append(System.lineSeparator());
        }

        // return string with deleted last system line separator
        return info.delete(info.length() - 2, info.length()).toString();
    }
}
