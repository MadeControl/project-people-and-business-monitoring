package com.madecontrol.projectpeopleandbusinessmonitoring.model.info;

public interface Information {

    String getInfo();

    String INFO_MAN = "Man: '%s'.";
    String INFO_ORGANIZATION = "Organization: '%s'.";
    String INFO_JOB = "Job: '%s'. Salary: %.2f %s.";
    String INFO_POSITION = "Position: '%s'. Salary: %.2f %s.";

    String INFO_OWNER = "\t* Owner: '%s' has coefficient %d%%.";
    String INFO_ITEM = "\t* Item: '%s'. Price: %.2f %s. Amount: %d. Full price: %.2f %s.";
    String INFO_MONEY = "\t* %.2f %s";

    String INFO_ITEM_TAG = "Personal items:";
    String INFO_INCOME_MONEY_TAG = "Income money:";
    String INFO_INVEST_MONEY_TAG = "Invest money:";
    String INFO_BUSINESS_TAG = "Business information:";

    String INFO_NOT_ARRESTED_BUSINESS_BY_OWNER = "\t* Business '%s'. Quantity: %d. " +
            "Price: %.2f %s. Coefficient: %d%%. Tax control: %b. " +
            "Invested: %.2f %s. Income: %.2f %s ";

    String INFO_ARRESTED_BUSINESS_BY_OWNER = "\t* Business '%s'. Quantity: %d. " +
            "Price: %.2f %s. Invested: %.2f %s. [ARRESTED]";

    String INFO_NOT_ARRESTED_INVESTMENT_BY_OWNER = "\t* Investment '%s'. Income percent %d%%. " +
            "Coefficient: %d%%. Tax control: %b. Invested: %.2f %s. Income: %.2f %s ";

    String INFO_ARRESTED_INVESTMENT_BY_OWNER = "\t* Investment '%s'. Income percent %d%%. " +
            "Invested: %.2f %s. [ARRESTED]";

    String INFO_NOT_ARRESTED_RENT_BY_OWNER = "\t* Rent '%s'. Quantity: %d. Sq.m.: %d. " +
            "Price of 1 sq.m.: %.2f %s. Coefficient: %d%%. Tax control: %b. Income: %.2f %s";

    String INFO_ARRESTED_RENT_BY_OWNER = "\t* Rent '%s'. Quantity: %d. " +
            "Price: %.2f %s. Sq.m.: %d. Price of 1 sq.m.: %.2f %s. Invested: %.2f %s. [ARRESTED]";

    String INFO_NOT_ARRESTED_RACKET_BY_OWNER = "\t* Racket '%s'. " +
            "Racket: %.2f %s. Quantity: %d. Coefficient: %d%%. Income: %.2f %s";

    String INFO_ARRESTED_RACKET_BY_OWNER = "\t* Racket '%s'. " +
            "Racket: %.2f %s. Quantity: %d. [ARRESTED]";

}
