Pod::Spec.new do |s|
    s.name         = "Transactions"
    s.version      = "0.0.5"
    s.summary      = "Make atomic changes to object hierarchies"
    s.description  = <<-DESC
                        Transactions framework facilitates making atomic changes to the model:

                        - It provides a generic mechanism to "link" coherent hierarchies of objects that are supposed to change their state synchronously and atomically.
                        - It defines call-back functions that are triggered on every object at every transaction start, pre-commit integrity check, commit, and rollback.
                        - It provides convenience method to wrap transactional code in closures. Such closures will be pre-pended by transaction start callbacks, post-pended by either commits or rollbacks, and will have an implicit integrity check ran for every member of the transaction context.
                        
                        This approach allows to encapsulate constraints checking and backup/restore operations within each individual class, thus placing related code together and making the whole logic clearer and easier to maintain.
                     DESC
    s.homepage     = "https://github.com/courteouselk/Transactions"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "Anton Bronnikov" => "anton.bronnikov@gmail.com" }

    s.ios.deployment_target     = "8.0"
    s.osx.deployment_target     = "10.10"

    s.source       = { :git => "https://github.com/courteouselk/Transactions.git", :tag => "#{s.version}" }
    s.source_files = "Sources/**/*.{swift,h}"
end
