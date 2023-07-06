public class SalesOrderTriggerHandler {
    
    public static void handleTrigger(List<Sales_Order__c> newSalesOrders, Map<Id, Sales_Order__c> oldSalesOrderMap) {
        
        // Collect relevant data for price calculation
        List<String> customerTypes = new List<String>();
        List<String> productCategories = new List<String>();
        Map<String, Price_Rule__c> priceRulesMap = new Map<String, Price_Rule__c>();

        // Fetch relevant price rules based on sales order conditions
        for (Sales_Order__c salesOrder : newSalesOrders) {
            customerTypes.add(salesOrder.Customer_Type__c);
            productCategories.add(salesOrder.Product_Category__c);
        }
        
        // Query price rules based on conditions
        List<Price_Rule__c> priceRules = [SELECT Id, Formula__c, Discount__c, Customer_Type__c, Product_Category__c
                                          FROM Price_Rule__c
                                          WHERE Customer_Type__c IN :customerTypes
                                          AND Product_Category__c IN :productCategories];
        
        // Create a map of price rules for easy lookup
        for (Price_Rule__c priceRule : priceRules) {
            String ruleKey = priceRule.Customer_Type__c + '-' + priceRule.Product_Category__c;
            priceRulesMap.put(ruleKey, priceRule);
        }
        
        // Calculate and update final prices for each sales order
        for (Sales_Order__c salesOrder : newSalesOrders) {
            String ruleKey = salesOrder.Customer_Type__c + '-' + salesOrder.Product_Category__c;
            Price_Rule__c priceRule = priceRulesMap.get(ruleKey);
            
            if (priceRule != null) {
                // Apply pricing calculation based on the rule
                Decimal finalPrice = calculateFinalPrice(salesOrder, priceRule);
                salesOrder.Final_Price__c = finalPrice;
            }
            else {
                // Handle the scenario when no matching price rule is found
                salesOrder.addError('No price rule found for the given conditions.');
            }
        }
    }
    
    public static Decimal calculateFinalPrice(Sales_Order__c salesOrder, Price_Rule__c priceRule) {
        Decimal finalPrice = 0;
        
        // Implement your pricing calculation logic here, based on the formula or discount specified in the price rule
        // You can access the sales order fields, such as quantity and any additional factors for calculation
        
        return finalPrice;
    }
}