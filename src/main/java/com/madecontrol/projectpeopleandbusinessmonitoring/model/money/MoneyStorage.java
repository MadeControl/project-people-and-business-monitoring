package com.madecontrol.projectpeopleandbusinessmonitoring.model.money;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.info.Information;

public interface MoneyStorage extends Information {

    void addMoney(double money, Currency currency);

}
