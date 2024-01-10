workspace "Quantech" "Description" {
    model {
        customer = person "Customer"
        admin = person "Admin"
        
        v2 = softwareSystem "V2 Client Webapp" {
            tags "V2"
            v2be = container "V2-BE" {
                description "1. Authentication\n 2. Customers\n 3. Transaction\n 4. Hotmatch\n 5. CRUD\n 6. Jobs/Worder(Invoice Handler, Invoice Validation)"
                
                technology ExpressJS
            }
                
            v2fe = container "V2-FE" {
                description "1. Authentication\n 2. User\n 3. Transaction\n 4. Hotmatch\n 5. CMS(news)"
            
                technology NuxtJS
            }
            
            gw = container "Gateway"
            
            v2wp = container "V2-Wordpress" {
                description "CMS(news, banner, hotmatch)"
            }
        }
        
        bo = softwareSystem "BO Business Operation Webapp" {
            tags "BO"
            bobe = container "BO-BE" {
                tags "LongDesc"
                technology NestJS
                
                description "1. Log in and Permission\n 2. Refresh Token\n 3. Admin Management\n 4. Trader Management\n 5. Betting Account Management\n 6. Purchase and Selling Tickets\n 7. Transaction History\n 8. Money/Point Transfer(same trader/different trader)\n 9. Commission import and distribution (Excel)\n 10. System Log(Transaction Action)\n 11. Analytic Report(Transaction, Trader, Bet)\n 12. User Registration Report(Mobile/Desktop)"
            }
            
            bofe = container "BO-FE" {
                technology NuxtJS
                
                description "1. Sign In\n 2. All Related modules(via API)\n 3. File Uploading(Excel Sheet)\n 4. Route Guards with role and permissions"
            }
        }
        
        thirdPartyPaymentGateway = softwareSystem "Third party Payment Gateway" {
            thirdparty = container "Third Party Services" {
                description "1. Payment checking(via webhook)\n 2. Transaction, Bank"
            }
        }
        
        admin -> bo
        customer -> v2
        v2 -> bo "produce via RabbitMQ"
        thirdPartyPaymentGateway -> bo "via webhook"
        
        mongo = element "MongoDB" {
            tags "Database"
        }
            
        es = element "Elasticsearch" {
            description "Data from MongoDB"
        }
            
        mq = element "RabbitMQ"
        
        bofe -> bobe
        bobe -> mongo
        mongo -> bobe
        
        v2be -> mq "produce"
        mq -> bobe "consume"
            
        v2fe -> gw
        gw -> v2fe
        gw -> v2be
        v2be -> gw
            
        v2be -> mongo
        mongo -> v2be
            
        bobe -> es "Consume RabbitMQ and CUD actions have been pushed to Elasticsearch via API"
        es -> bobe
            
        thirdparty -> bobe
        thirdparty -> v2be
            
        v2wp -> v2be
    }
    
    views {
        systemlandscape "SystemLandscape" {
            include *
            autoLayout
        }
    
        systemContext bo {
            include v2
            include thirdPartyPaymentGateway
            include admin
            include customer
            autoLayout
        }
        
        systemContext v2 {
            include bo
            include thirdPartyPaymentGateway
            include admin
            include customer
            autoLayout
        }
    
        container bo {
            include *
            autoLayout
        }
        
        container v2 {
            include *
            autoLayout
        }
        
        styles {
            element "Database" {
                shape cylinder
                background Green
                color white
            }
            
            element "LongDesc" {
                height 600
            }
            
            element "Person" {
                shape person
                color White
                background Blue
            }
            
            element "BO" {
                background Red
                color White
            }
            
            element "V2" {
                color White
                background Red
            }
        }
    }
}