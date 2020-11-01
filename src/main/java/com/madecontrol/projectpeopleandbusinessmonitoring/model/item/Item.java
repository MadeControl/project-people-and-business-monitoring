package com.madecontrol.projectpeopleandbusinessmonitoring.model.item;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.info.Information;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;

public interface Item extends Information {

    double getFullPrice();

    Currency getCurrency();

}
