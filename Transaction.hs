
module Transaction
where
import Utils
import Types
import AccountName
import Amount


instance Show Transaction where show = showTransaction

showTransaction t = (showAccountName $ taccount t) ++ "  " ++ (showAmount $ tamount t) 
showAmount amt = printf "%11s" (show amt)
showAccountName s = printf "%-22s" (elideRight 22 s)

elideRight width s =
    case length s > width of
      True -> take (width - 2) s ++ ".."
      False -> s

autofillTransactions :: [Transaction] -> [Transaction]
autofillTransactions ts =
    let (ns, as) = partition isNormal ts
            where isNormal t = (symbol $ currency $ tamount t) /= "AUTO" in
    case (length as) of
      0 -> ns
      1 -> ns ++ [balanceTransaction $ head as]
          where balanceTransaction t = t{tamount = -(sumTransactions ns)}
      otherwise -> error "too many blank transactions in this entry"

sumTransactions :: [Transaction] -> Amount
sumTransactions ts = sum [tamount t | t <- ts]

