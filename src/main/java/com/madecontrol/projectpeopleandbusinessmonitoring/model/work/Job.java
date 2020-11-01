package com.madecontrol.projectpeopleandbusinessmonitoring.model.work;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;

public class Job extends Work {

    public Job(String name, double salary, Currency currency) {
        super(name, salary, currency);
    }

    @Override
    public String getInfo() {
        return String.format(INFO_JOB, getName(), getSalary(), getCurrency());
    }
}
