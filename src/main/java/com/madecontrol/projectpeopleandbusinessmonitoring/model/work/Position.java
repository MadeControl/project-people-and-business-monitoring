package com.madecontrol.projectpeopleandbusinessmonitoring.model.work;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;

public class Position extends Work {

    public Position(String name, double salary, Currency currency) {
        super(name, salary, currency);
    }

    @Override
    public String getInfo() {
        return String.format(INFO_POSITION, getName(), getSalary(), getCurrency());
    }
}
