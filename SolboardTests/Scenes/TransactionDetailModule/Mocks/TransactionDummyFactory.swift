//
//  TransactionDummyFactory.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 08/05/2024.
//

import Foundation
@testable import Solboard

struct TransactionDummyFactory {
    static func getResponse() -> GetSignatureResponse? {
        let json = transactionTokenSuccessJson.data(using: .utf8)!
        
        do {
            return try JSONDecoder().decode(GetSignatureResponse.self, from: json)
        } catch let error {
            print("Error", error)
            return nil
        }
    }
    
    static func getFailResponse() -> GetSignatureResponse? {
        let json = transactionFailedJson.data(using: .utf8)!
        
        do {
            return try JSONDecoder().decode(GetSignatureResponse.self, from: json)
        } catch let error {
            print("Error", error)
            return nil
        }
    }
}

let transactionSuccessJson = """
{
    "jsonrpc": "2.0",
    "result": {
        "blockTime": 1714741276,
        "meta": {
            "computeUnitsConsumed": 5736,
            "err": null,
            "fee": 65000,
            "innerInstructions": [],
            "loadedAddresses": {
                "readonly": [],
                "writable": []
            },
            "logMessages": ["Program ComputeBudget111111111111111111111111111111 invoke [1]", "Program ComputeBudget111111111111111111111111111111 success", "Program BanxBXWfsNL1Fg2dwJV6ZJ5qBieYn9pHqb5PAVrwPigN invoke [1]", "Program log: Instruction: CloseAllocation", "Program BanxBXWfsNL1Fg2dwJV6ZJ5qBieYn9pHqb5PAVrwPigN consumed 5586 of 199850 compute units", "Program BanxBXWfsNL1Fg2dwJV6ZJ5qBieYn9pHqb5PAVrwPigN success"],
            "postBalances": [34051596916, 270090823, 0, 1, 1141440, 1, 1009200],
            "postTokenBalances": [],
            "preBalances": [34050158556, 270090823, 1503360, 1, 1141440, 1, 1009200],
            "preTokenBalances": [],
            "rewards": [],
            "status": {
                "Ok": null
            }
        },
        "slot": 263644237,
        "transaction": {
            "message": {
                "accountKeys": ["9J4yDqU6wBkdhP5bmJhukhsEzBkaAXiBmii52kTdxpQq", "AUXVBHMKvW6arSPPNbjSuz8y3f6HA2p8YCcKLr8HBGdh", "BqvcnYQHLx2NPWv1DwyCpHPZLxdREcKiwDUXedCTZbT5", "11111111111111111111111111111111", "BanxBXWfsNL1Fg2dwJV6ZJ5qBieYn9pHqb5PAVrwPigN", "ComputeBudget111111111111111111111111111111", "SysvarRent111111111111111111111111111111111"],
                "header": {
                    "numReadonlySignedAccounts": 0,
                    "numReadonlyUnsignedAccounts": 4,
                    "numRequiredSignatures": 1
                },
                "instructions": [{
                    "accounts": [],
                    "data": "3s2DQSEX3t4P",
                    "programIdIndex": 5,
                    "stackHeight": null
                }, {
                    "accounts": [0, 2, 1, 3, 6],
                    "data": "3MmgM6QXvgrD9ioaSi3XxKm9",
                    "programIdIndex": 4,
                    "stackHeight": null
                }],
                "recentBlockhash": "36tppqND4atnAUHffrgpckoQqw6MUes8xwpvtFw4x2j7"
            },
            "signatures": ["ru1YT52k3jhCZiczamXWUtzFbRvTo4pbxonhRaEszRDkz7mLHxv9PWMCSq3UHgyDBfsRjmjUpUZH3LXhcv1J7tU"]
        }
    },
    "id": 1
}
"""

let transactionTokenSuccessJson = """
{
    "jsonrpc": "2.0",
    "result": {
        "blockTime": 1715216880,
        "meta": {
            "computeUnitsConsumed": 140469,
            "err": null,
            "fee": 9377,
            "innerInstructions": [{
                "index": 3,
                "instructions": [{
                    "accounts": [7],
                    "data": "46Rx8B459FZTyNnSh8Rvs91oKMeP11AmegsFmxg7MReyWgeAgbaHqEWXGSSzD9FNR7NgufVXF518Z1zDC3VP1G6NLj3UvCxMawSPMvEbHX3x3LVpaXQhWxyKxaDV5YUk1n3xPc1ibejx36NM8i8WZmqcydWb3KmFQzAXkMVobpQVBeTu6XjWy4e4Btu8xrZr2WQcQVuJ64YQzdJej9b7YVRB2s63UazWoDwwM1b5hGKyr6HkEQhsQ1QE2SZ9mxY8R3RcDLJyTXAsHuLM4VjNdRPSN9ybHPpkvzhk792d55r74XHxQASXTvBuy7kz6EBGda61Za1gm9MGc1JYc9xxDiVJMQoZ763dnnnmPqmKxxhNmemX1NJRqybdQx4n73girjcHUwYN3unFFhmzXAUyjpRMwsCUtovHc5nAn1Qvt1oK3YET86HQzEuhHxfJbK2Lyfpg5NNB1KWVEkfScPzzJDtgKNxg5gpW7wSEyFQJMsBszMDgGoapbuwFQjxobAehBnQmjV4ecpGFfcPAju5zoEzmM4LBQzqnQEyzu86rpd6pd65Yu7nDwRmWLvPomRxgYGaCXmMqBLHT1rMtKdWcbAHJR8LoDFtNGYa6sofnQgyhGbg1gVqZhSzXf38F6XFNqpDAgRSvm8ovZQsM3dx36LhpEGgf6KU9xdRLZojBn6VeYwThC3s3AeYTcFvq9pvHr39qq4uLT8s2cFso3ihRuuD1C4jpkobsVVFYrbYLQmAGDg6W38TypZUpwM8pVmmEu1quC3dNPuVVzkYJpQctf85XFT9Pud4WPsNGWCENyXBxvMGNaDhrNXq3JJDSFwbsBCXxdD8paTkb",
                    "programIdIndex": 11,
                    "stackHeight": 2
                }]
            }, {
                "index": 4,
                "instructions": [{
                    "accounts": [7],
                    "data": "3kE2C7FQz3aKYBXkNYMuzscMroTRNnLqqpZVojNBJC64xovk9cR9m8zZY2CFrst1CXSjpxKHuTLngDArGUBSXzqj8KfSzNCfvKZ8G9RcqE6tKBwEtTyniVqVvdCAppRKT1fH1GZkarVNTxYpDoeicn1kNPpToGzvbusp7uqB8SMkJT6G7Hctr6uKghJSvnogumoy7LkPdGiQGKUMLu6VNh2vUbFJrCEfYXRDynVbY5XcPNN9wvcRzrTvE6X8GveVcqMP7PDSpSoMcXcbJ9ztAReWa5NuD3dA4B5qogpBbRG1krX23saikhJH8LCwrrkjLbEheJNjTMDwLeBnpBfEf38nSubAEhshpvdKfh2w58zvf5i4UBReqkvE1eer8mQ618rH6JQY55KEvGjknfyqJwRgGJxLRPoV3udYM1WC7W7RcMqugZVbxf3xnGPVAWvHnugDPgN3sCKFpKUFXwLHfpHZhoYRbwSyFw2UegUaaLUCAKHhxKtvCDdT7gDGbf1BfNe7Dq7yKCxvTADMvtVWTzAeSprSinZE2WZG7fnBEzKZcXumBS95qS3ua7kyWiaQzVygKt9UMGC3E5QkeMJWBkZNfbMkqiDPw8pRxsahHjuuHAk1CYy1M7vFnyQWyMonuS8Y5XYWemQeDHcD1jFxQSdWRyLzUUj26ETWJijh97r3GojZTouYEgycFpp1VuP6j9touA9pxGrArf5K5eJFmyFJ3BqDJvNx1Yj9Xwea2T8BjT1hUH4J6Up1mNur4KHcNkaTu1RuWmWEw3cwotogT75r54YtXxkCBPeUtnvgjEfJEmaMWxSboZbfUmsPHR6daSm7gEuc2wdKazvYZyrFvTMv6vfn4XES1XbXuE2Vd372HnS2eVurUETgpYnZzMairxGcTphRj5fJbgJvMXXd6iUycUxEijSYSZTWhxVkexXkt9N1e4CGnBsySkTU6rsBSfLR795gH7LbZJYnwscN7gi2Wm7iyJ2qXGtD8W1GrtzGUNpwgXimk5TVgaEeBnkTohdronwcWTNktELrowbFEDgQyD7dij9QTh4BM1956AErXEhCT1SnbzDFsPpqo6W9baujxGELN47mDv7VEowjmZzyVzw2c7jMPrvt8gkbT6hxwVRFwqs48tRzsJeDH48pMUBP4C3aRbyXL7wJboHHgQCJ5ecQxuYp9mFP5bQeXoZ7TYoNHvNyUF5ceqNk64dafCdfAWdNtYPiJDvHwHExtYELN9GhEPq6sLDpJsAnaARBatycgTsLs6g1gxzcBuQbiyWQjWTxdBh56wmiRqB8Yvo9Bod55sXc3Djq2s3cFbT9wAS2CmAR5AnQgFMKktJTp3fpcNFQaxmu1wMgU3Ps9XTodTfWRRtjR9iQFKSK7VJCqMkdy7PzNoryCWXqEP98NUF5pDjti3ukdJGTGkA3yzCVTAkq9RPYsb5RtBh5Bhntyix6dsg6XPxkMQNoFyrjzqdjHfRiHjCUwX8w1nzAr9QATmATMgWgnUFpJarTgpZuW3dGTwgukHkadNJa1xXH2UauyXy6EeybWQ9c282HRnMT5",
                    "programIdIndex": 11,
                    "stackHeight": 2
                }]
            }, {
                "index": 5,
                "instructions": [{
                    "accounts": [6, 5, 6],
                    "data": "3p3BdRBVuejh",
                    "programIdIndex": 12,
                    "stackHeight": 2
                }, {
                    "accounts": [3, 2, 3],
                    "data": "3s4cKbwn8CB9",
                    "programIdIndex": 12,
                    "stackHeight": 2
                }, {
                    "accounts": [7],
                    "data": "4VCmRtNmT9cxPPvxu6rZR4UQSTSKv6GwJUSidNydXi71T4nGhwhvintRUMjx1kBRCKK3nLDzzz936JuKeCNFy8cjV4bMwQEmJwyDvcb9Tx3ESvZkDrdGMPoCiuMfh59",
                    "programIdIndex": 11,
                    "stackHeight": 2
                }]
            }],
            "loadedAddresses": {
                "readonly": [],
                "writable": []
            },
            "logMessages": ["Program ComputeBudget111111111111111111111111111111 invoke [1]", "Program ComputeBudget111111111111111111111111111111 success", "Program ComputeBudget111111111111111111111111111111 invoke [1]", "Program ComputeBudget111111111111111111111111111111 success", "Program GDDMwNyyx8uB6zrqwBFHjLLG3TBYk2F8Az4yrQC5RzMp invoke [1]", "Program log: Sequence in order | sequence_num=679559 | last_known=679557", "Program GDDMwNyyx8uB6zrqwBFHjLLG3TBYk2F8Az4yrQC5RzMp consumed 3398 of 349700 compute units", "Program GDDMwNyyx8uB6zrqwBFHjLLG3TBYk2F8Az4yrQC5RzMp success", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY invoke [1]", "Program log: Discriminant for phoenix::program::accounts::MarketHeader is 8167313896524341111", "Program log: PhoenixInstruction::CancelAllOrdersWithFreeFunds", "Program consumption: 342442 units remaining", "Program consumption: 311979 units remaining", "Program log: Sending batch 1 with header and 15 market events, total events sent: 15", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY invoke [2]", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY consumed 582 of 309559 compute units", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY success", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY consumed 37693 of 346302 compute units", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY success", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY invoke [1]", "Program log: Discriminant for phoenix::program::accounts::MarketHeader is 8167313896524341111", "Program log: PhoenixInstruction::PlaceMultiplePostOnlyOrders", "Program log: Discriminant for phoenix::program::accounts::Seat is 2002603505298356104", "Program log: Insufficient funds to place order: 13543262 base lots available, 29942636 base lots required", "Program log: Sending batch 1 with header and 30 market events, total events sent: 30", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY invoke [2]", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY consumed 582 of 238446 compute units", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY success", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY consumed 71802 of 308609 compute units", "Program return: PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY DwAAANtMAAAAAAAAFKsM+P/////HTAAAAAAAABOrDPj/////pUwAAAAAAAASqwz4/////31MAAAAAAAAEasM+P////9WTAAAAAAAABCrDPj/////9EsAAAAAAAAPqwz4/////0xLAAAAAAAADqsM+P////90SQAAAAAAAA2rDPj//////EwAAAAAAADzVPMHAAAAABBNAAAAAAAA9FTzBwAAAAAyTQAAAAAAAPVU8wcAAAAAWU0AAAAAAAD2VPMHAAAAAIFNAAAAAAAA91TzBwAAAADjTQAAAAAAAPhU8wcAAAAAY1AAAAAAAAD5VPMHAAAAAA==", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY success", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY invoke [1]", "Program log: Discriminant for phoenix::program::accounts::MarketHeader is 8167313896524341111", "Program log: PhoenixInstruction::WithdrawFunds", "Program consumption: 228795 units remaining", "Program consumption: 228684 units remaining", "Program consumption: 227795 units remaining", "Program consumption: 227688 units remaining", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [2]", "Program log: Instruction: Transfer", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 4645 of 224998 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [2]", "Program log: Instruction: Transfer", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 4554 of 217681 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program log: Sending batch 1 with header and 0 market events, total events sent: 0", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY invoke [2]", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY consumed 582 of 210651 compute units", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY success", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY consumed 27276 of 236807 compute units", "Program PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY success"],
            "postBalances": [5241166275, 1224960, 2039280, 3339399, 3370961611, 330737691947, 7595968862679, 0, 1781760, 1, 1141440, 1141440, 934087680],
            "postTokenBalances": [{
                "accountIndex": 2,
                "mint": "EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm",
                "owner": "phxBcughCYKiYJxx9kYEkyqoAUL2RD3vyxSaL1gZRNG",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "10216302525",
                    "decimals": 6,
                    "uiAmount": 10216.302525,
                    "uiAmountString": "10216.302525"
                }
            }, {
                "accountIndex": 3,
                "mint": "EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm",
                "owner": "9WAfKnMYebxsaURpim6YpU1FFzG5R57FzSaUbGt6Eejy",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "302814574000",
                    "decimals": 6,
                    "uiAmount": 302814.574,
                    "uiAmountString": "302814.574"
                }
            }, {
                "accountIndex": 5,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "phxBcughCYKiYJxx9kYEkyqoAUL2RD3vyxSaL1gZRNG",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "330735652667",
                    "decimals": 9,
                    "uiAmount": 330.735652667,
                    "uiAmountString": "330.735652667"
                }
            }, {
                "accountIndex": 6,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "GhoCmSmpyM9gedtWmgT3vMknE5av9iiehLt6rrTog4qK",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "7595940803399",
                    "decimals": 9,
                    "uiAmount": 7595.940803399,
                    "uiAmountString": "7595.940803399"
                }
            }],
            "preBalances": [5241175652, 1224960, 2039280, 3339399, 3370961611, 330267488093, 7596439066533, 0, 1781760, 1, 1141440, 1141440, 934087680],
            "preTokenBalances": [{
                "accountIndex": 2,
                "mint": "EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm",
                "owner": "phxBcughCYKiYJxx9kYEkyqoAUL2RD3vyxSaL1gZRNG",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "10212578525",
                    "decimals": 6,
                    "uiAmount": 10212.578525,
                    "uiAmountString": "10212.578525"
                }
            }, {
                "accountIndex": 3,
                "mint": "EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm",
                "owner": "9WAfKnMYebxsaURpim6YpU1FFzG5R57FzSaUbGt6Eejy",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "302818298000",
                    "decimals": 6,
                    "uiAmount": 302818.298,
                    "uiAmountString": "302818.298"
                }
            }, {
                "accountIndex": 5,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "phxBcughCYKiYJxx9kYEkyqoAUL2RD3vyxSaL1gZRNG",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "330265448813",
                    "decimals": 9,
                    "uiAmount": 330.265448813,
                    "uiAmountString": "330.265448813"
                }
            }, {
                "accountIndex": 6,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "GhoCmSmpyM9gedtWmgT3vMknE5av9iiehLt6rrTog4qK",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "7596411007253",
                    "decimals": 9,
                    "uiAmount": 7596.411007253,
                    "uiAmountString": "7596.411007253"
                }
            }],
            "rewards": [],
            "status": {
                "Ok": null
            }
        },
        "slot": 264673157,
        "transaction": {
            "message": {
                "accountKeys": ["phxBcughCYKiYJxx9kYEkyqoAUL2RD3vyxSaL1gZRNG", "53kQL2yYcuSxuR7zomnLP7Jv6QX8ean1uSgkwiX1fKs7", "71rfmyvgBXNcY7CsMkbJdV14afUEW4y1giGPsZ4maWMZ", "9WAfKnMYebxsaURpim6YpU1FFzG5R57FzSaUbGt6Eejy", "BKLhZ5NrFhCjViC4wyAMXBNsJFHbFfYujo3TtUmBxTH3", "EkMuMduwxS3NVTm8jd5WywVXZALzKJoHrCdKAwxvmXea", "GhoCmSmpyM9gedtWmgT3vMknE5av9iiehLt6rrTog4qK", "7aDTsspkQNGKmrexAN7FLx9oxU3iPczSSvHNggyuqYkR", "AgiduxYpG3XenRvb4zfanHnRhJykcmnncR2fUfEwkW5B", "ComputeBudget111111111111111111111111111111", "GDDMwNyyx8uB6zrqwBFHjLLG3TBYk2F8Az4yrQC5RzMp", "PhoeNiXZ8ByJGLkxNfZRnkUfjvmuYqLR89jjFHGqdXY", "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"],
                "header": {
                    "numReadonlySignedAccounts": 0,
                    "numReadonlyUnsignedAccounts": 6,
                    "numRequiredSignatures": 1
                },
                "instructions": [{
                    "accounts": [],
                    "data": "3qT9ikGxWiMV",
                    "programIdIndex": 9,
                    "stackHeight": null
                }, {
                    "accounts": [],
                    "data": "FKjJ6B",
                    "programIdIndex": 9,
                    "stackHeight": null
                }, {
                    "accounts": [1, 0],
                    "data": "Bz9KX2mGFbq6VPP2epqRbV",
                    "programIdIndex": 10,
                    "stackHeight": null
                }, {
                    "accounts": [11, 7, 4, 0],
                    "data": "8",
                    "programIdIndex": 11,
                    "stackHeight": null
                }, {
                    "accounts": [11, 7, 4, 0, 8, 2, 5, 3, 6, 12],
                    "data": "4SWExuAMmQojUHnYjbwskN9yZ1s6nWYUHDpMWcs8opyjAg4Rq69ahmUiwttgvNefDdGTp3eXBEmZK2s6ynpRJQoartw8YNnXrExVsw4N9RSG21VfiYygQ3mwpLrPHctshr8LYMhBJtuQykueYpasGkw9W7aDiAv56gTsswmgRLzwoHpNkjN3RZ3PbrKnZrqgbinaY7xMkRfXNbTZAp665d1ur1q7HCtNWuXKJdRCw7NzoN6hm6WUiJfK5iiV6oXbQKHYfcN1wSCetTYeuKvubTAZW8Ua5URLTQyscrzac5RuJrZGqB1pChhjpTu7bFW87uczzgYqDzfNN77GbE281jkAYnS4EXZBfg37u7eSW8X4tVS5N9bQ7ZrMmzhMRbUuzh4f7J7TSm3A4w1sik7jKVXcCkUHVanPVzVECUj1hLRcQX3GMa2tMpLdPhDEAZMoWJkK557weRcLkjuFJN9K3qYAmQoqLoRy22NxQvdQHRtHUwpTdDwGys3NTausnRxdP6HmHTcAwBQAdW4uvGuHRUmNn5Lt5A8VLAzd3o7Xn1C2HMwMXr6nc8c6e5TMVLBHA6XNDk7H9kGq86o1DPfmrRAaBfXBP",
                    "programIdIndex": 11,
                    "stackHeight": null
                }, {
                    "accounts": [11, 7, 4, 0, 2, 5, 3, 6, 12],
                    "data": "52nB",
                    "programIdIndex": 11,
                    "stackHeight": null
                }],
                "recentBlockhash": "B7J7CLN4hoojtwXQEqm1HdaiaMK2jv5pv9SUyjMuAya1"
            },
            "signatures": ["35Fi7aFkxwXPDxMLiyPaneTyHfsGmHNZnrJAPBVJwJCgftMkpMKtJWkJqHLaRdK4DbohRmJeiHGcJbi261tZbKNA"]
        },
        "version": "legacy"
    },
    "id": 1
}
"""

let transactionFailedJson = """
{
    "jsonrpc": "2.0",
    "result": {
        "blockTime": 1712916375,
        "meta": {
            "computeUnitsConsumed": 135910,
            "err": {
                "InstructionError": [6, {
                    "Custom": 6001
                }]
            },
            "fee": 105000,
            "innerInstructions": [{
                "index": 2,
                "instructions": [{
                    "accounts": [8],
                    "data": "84eT",
                    "programIdIndex": 9,
                    "stackHeight": 2
                }, {
                    "accounts": [0, 3],
                    "data": "11119os1e9qSs2u7TsThXqkBSRVFxhmYaFKFZ1waB2X7armDmvK3p5GmLdUxYdg3h7QSrL",
                    "programIdIndex": 5,
                    "stackHeight": 2
                }, {
                    "accounts": [3],
                    "data": "P",
                    "programIdIndex": 9,
                    "stackHeight": 2
                }, {
                    "accounts": [3, 8],
                    "data": "6WcEA7Ut8DMNR7vUuTkvnPxaMYYg6Zn5qF7nAqRp6UR4f",
                    "programIdIndex": 9,
                    "stackHeight": 2
                }]
            }, {
                "index": 5,
                "instructions": [{
                    "accounts": [12],
                    "data": "84eT",
                    "programIdIndex": 9,
                    "stackHeight": 2
                }, {
                    "accounts": [0, 2],
                    "data": "11119os1e9qSs2u7TsThXqkBSRVFxhmYaFKFZ1waB2X7armDmvK3p5GmLdUxYdg3h7QSrL",
                    "programIdIndex": 5,
                    "stackHeight": 2
                }, {
                    "accounts": [2],
                    "data": "P",
                    "programIdIndex": 9,
                    "stackHeight": 2
                }, {
                    "accounts": [2, 12],
                    "data": "6WcEA7Ut8DMNR7vUuTkvnPxaMYYg6Zn5qF7nAqRp6UR4f",
                    "programIdIndex": 9,
                    "stackHeight": 2
                }]
            }, {
                "index": 6,
                "instructions": [{
                    "accounts": [3, 8, 4, 0],
                    "data": "g7MTnjx8KtVSx",
                    "programIdIndex": 9,
                    "stackHeight": 2
                }, {
                    "accounts": [9, 23, 25, 18, 20, 22, 24, 21, 17, 15, 19, 16, 14, 27, 4, 1, 10],
                    "data": "5uaP523NwwKgafYyw8t73D1",
                    "programIdIndex": 26,
                    "stackHeight": 2
                }, {
                    "accounts": [4, 20, 10],
                    "data": "3DYtTq2vb8pX",
                    "programIdIndex": 9,
                    "stackHeight": 3
                }, {
                    "accounts": [22, 1, 25],
                    "data": "3Zh1pvoa62RM",
                    "programIdIndex": 9,
                    "stackHeight": 3
                }, {
                    "accounts": [13],
                    "data": "QMqFu4fYGGeUEysFnenhAvR83g86EDDNxzUskfkWKYCBPWe1hqgD6jgKAXr6aYoEQaxoqYMTvWgPVk2AHWGHjdbNiNtoaPfZA4znu6cRUSWSeJFUa4ZBTehqpKCVzQZoNMij4ZTETkxYYwLmmFiz1sj7EBquMqd7r15RSrh1YUHYx8w",
                    "programIdIndex": 7,
                    "stackHeight": 2
                }]
            }],
            "loadedAddresses": {
                "readonly": ["srmqPvymJeFKQ4zGQed1GFppgkRHL9kaELCbyksJtPX", "5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1", "675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8", "6Gh9riy7XeiLkDNAFWiBrqBCvn3MLBBJWtjHJv3uBUi9"],
                "writable": ["2S1Vgp2XuCFbfRwESKUbVX58eagLUzvkGy7jkUA3rcxx", "3pGrGXKoMwfUm4hBvXGXMkxUWpNMyBM4HwVAcyCHMNMr", "4T6A1VEggLQi1d7wXuVutpHHQ8okQRbeuHMNCvski43S", "7BRAA9uTdSWyjxvGb5T8UBJXuuwvDibpcEUaxAAxStHK", "7wyquViujAMmZpuf86KZ937yqWrf8fU7BK7E5QENSWP9", "8BrnCeGvaZXLYcQYVBrj39wioTKs81jxoTkNWFdijbix", "CVqbmnG4mbquuUcAQFoGU9bCoiFcdvjTGkZAQNhPmv5U", "D1YKydP4yooVhtJu8TSMePzNhH6HbqLHALPMAcS9NNU6", "FcwTFyst8wXjs5PsVAn1xMHTvTYRXxRqZuUQSKXcXD3h", "Ht8jUAL6k2GUvG8W24Wt28B2ywzUwzMMRuBETUtyvPa9"]
            },
            "logMessages": ["Program ComputeBudget111111111111111111111111111111 invoke [1]", "Program ComputeBudget111111111111111111111111111111 success", "Program ComputeBudget111111111111111111111111111111 invoke [1]", "Program ComputeBudget111111111111111111111111111111 success", "Program ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL invoke [1]", "Program log: CreateIdempotent", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [2]", "Program log: Instruction: GetAccountDataSize", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 1569 of 177542 compute units", "Program return: TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA pQAAAAAAAAA=", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program 11111111111111111111111111111111 invoke [2]", "Program 11111111111111111111111111111111 success", "Program log: Initialize the associated token account", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [2]", "Program log: Instruction: InitializeImmutableOwner", "Program log: Please upgrade to SPL Token 2022 for immutable owner support", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 1405 of 170955 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [2]", "Program log: Instruction: InitializeAccount3", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 3158 of 167073 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL consumed 19315 of 182947 compute units", "Program ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL success", "Program 11111111111111111111111111111111 invoke [1]", "Program 11111111111111111111111111111111 success", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [1]", "Program log: Instruction: SyncNative", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 3045 of 163482 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL invoke [1]", "Program log: CreateIdempotent", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [2]", "Program log: Instruction: GetAccountDataSize", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 1569 of 152032 compute units", "Program return: TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA pQAAAAAAAAA=", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program 11111111111111111111111111111111 invoke [2]", "Program 11111111111111111111111111111111 success", "Program log: Initialize the associated token account", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [2]", "Program log: Instruction: InitializeImmutableOwner", "Program log: Please upgrade to SPL Token 2022 for immutable owner support", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 1405 of 145445 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [2]", "Program log: Instruction: InitializeAccount3", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 4188 of 141563 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL consumed 23345 of 160437 compute units", "Program ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL success", "Program JUP6LkbZbjS1jKKwapdHNy74zcZ3tLUZoi5QNyVTaV4 invoke [1]", "Program log: Instruction: SharedAccountsRoute", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [2]", "Program log: Instruction: TransferChecked", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 6238 of 119819 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program 675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8 invoke [2]", "Program log: ray_log: AwCMhkcAAAAAAAAAAAAAAAACAAAAAAAAAFIDcFEAAAAAzgettVIAAAAkd0ZmNDIAAHj1dikrAAAA", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [3]", "Program log: Instruction: Transfer", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 4736 of 69991 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA invoke [3]", "Program log: Instruction: Transfer", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA consumed 4645 of 62274 compute units", "Program TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA success", "Program 675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8 consumed 31003 of 87864 compute units", "Program 675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8 success", "Program JUP6LkbZbjS1jKKwapdHNy74zcZ3tLUZoi5QNyVTaV4 invoke [2]", "Program JUP6LkbZbjS1jKKwapdHNy74zcZ3tLUZoi5QNyVTaV4 consumed 2021 of 53882 compute units", "Program JUP6LkbZbjS1jKKwapdHNy74zcZ3tLUZoi5QNyVTaV4 success", "Program log: AnchorError occurred. Error Code: SlippageToleranceExceeded. Error Number: 6001. Error Message: Slippage tolerance exceeded.", "Program JUP6LkbZbjS1jKKwapdHNy74zcZ3tLUZoi5QNyVTaV4 consumed 89755 of 137092 compute units", "Program JUP6LkbZbjS1jKKwapdHNy74zcZ3tLUZoi5QNyVTaV4 failed: custom program error: 0x1771"],
            "postBalances": [1436283214, 2039280, 0, 0, 168334658, 1, 1, 1141440, 523504186769, 934087680, 231603231, 731913600, 501461600, 0, 2039280, 457104960, 2039280, 457104960, 23357760, 1825496640, 355237373374, 3591360, 2039280, 6124800, 1141440, 2792005820, 1141440, 0],
            "postTokenBalances": [{
                "accountIndex": 1,
                "mint": "BKQoRwtpzKyjKqxbUe9VZmXoBtjwsJFRoAKu1sweVoDM",
                "owner": "2MFoS3MPtvyQ4Wh4M9pdfPjz6UhVoNbFbGJAskCPCj3h",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "0",
                    "decimals": 6,
                    "uiAmount": null,
                    "uiAmountString": "0"
                }
            }, {
                "accountIndex": 4,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "2MFoS3MPtvyQ4Wh4M9pdfPjz6UhVoNbFbGJAskCPCj3h",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "166295378",
                    "decimals": 9,
                    "uiAmount": 0.166295378,
                    "uiAmountString": "0.166295378"
                }
            }, {
                "accountIndex": 14,
                "mint": "BKQoRwtpzKyjKqxbUe9VZmXoBtjwsJFRoAKu1sweVoDM",
                "owner": "6Gh9riy7XeiLkDNAFWiBrqBCvn3MLBBJWtjHJv3uBUi9",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "0",
                    "decimals": 6,
                    "uiAmount": null,
                    "uiAmountString": "0"
                }
            }, {
                "accountIndex": 16,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "6Gh9riy7XeiLkDNAFWiBrqBCvn3MLBBJWtjHJv3uBUi9",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "0",
                    "decimals": 9,
                    "uiAmount": null,
                    "uiAmountString": "0"
                }
            }, {
                "accountIndex": 20,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "355235334094",
                    "decimals": 9,
                    "uiAmount": 355.235334094,
                    "uiAmountString": "355.235334094"
                }
            }, {
                "accountIndex": 22,
                "mint": "BKQoRwtpzKyjKqxbUe9VZmXoBtjwsJFRoAKu1sweVoDM",
                "owner": "5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "55200635582244",
                    "decimals": 6,
                    "uiAmount": 55200635.582244,
                    "uiAmountString": "55200635.582244"
                }
            }],
            "preBalances": [1436388214, 2039280, 0, 0, 168334658, 1, 1, 1141440, 523504186769, 934087680, 231603231, 731913600, 501461600, 0, 2039280, 457104960, 2039280, 457104960, 23357760, 1825496640, 355237373374, 3591360, 2039280, 6124800, 1141440, 2792005820, 1141440, 0],
            "preTokenBalances": [{
                "accountIndex": 1,
                "mint": "BKQoRwtpzKyjKqxbUe9VZmXoBtjwsJFRoAKu1sweVoDM",
                "owner": "2MFoS3MPtvyQ4Wh4M9pdfPjz6UhVoNbFbGJAskCPCj3h",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "0",
                    "decimals": 6,
                    "uiAmount": null,
                    "uiAmountString": "0"
                }
            }, {
                "accountIndex": 4,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "2MFoS3MPtvyQ4Wh4M9pdfPjz6UhVoNbFbGJAskCPCj3h",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "166295378",
                    "decimals": 9,
                    "uiAmount": 0.166295378,
                    "uiAmountString": "0.166295378"
                }
            }, {
                "accountIndex": 14,
                "mint": "BKQoRwtpzKyjKqxbUe9VZmXoBtjwsJFRoAKu1sweVoDM",
                "owner": "6Gh9riy7XeiLkDNAFWiBrqBCvn3MLBBJWtjHJv3uBUi9",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "0",
                    "decimals": 6,
                    "uiAmount": null,
                    "uiAmountString": "0"
                }
            }, {
                "accountIndex": 16,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "6Gh9riy7XeiLkDNAFWiBrqBCvn3MLBBJWtjHJv3uBUi9",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "0",
                    "decimals": 9,
                    "uiAmount": null,
                    "uiAmountString": "0"
                }
            }, {
                "accountIndex": 20,
                "mint": "So11111111111111111111111111111111111111112",
                "owner": "5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "355235334094",
                    "decimals": 9,
                    "uiAmount": 355.235334094,
                    "uiAmountString": "355.235334094"
                }
            }, {
                "accountIndex": 22,
                "mint": "BKQoRwtpzKyjKqxbUe9VZmXoBtjwsJFRoAKu1sweVoDM",
                "owner": "5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1",
                "programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
                "uiTokenAmount": {
                    "amount": "55200635582244",
                    "decimals": 6,
                    "uiAmount": 55200635.582244,
                    "uiAmountString": "55200635.582244"
                }
            }],
            "rewards": [],
            "status": {
                "Err": {
                    "InstructionError": [6, {
                        "Custom": 6001
                    }]
                }
            }
        },
        "slot": 259696492,
        "transaction": {
            "message": {
                "accountKeys": ["AUXVBHMKvW6arSPPNbjSuz8y3f6HA2p8YCcKLr8HBGdh", "2aFBxavLDbc3hV1ernpfWHMnT4yEjL7JBhP3rSEbB6rc", "FtQSoTfBPVdZC5wRUDniSghXqEZEoM2MEw3i46iMG4xf", "GcbbZQb8nmg1ofuMEW2jGXkX5qiPfnaEG5mVH8axpTJZ", "H1qQ6Hent1C5wa4Hc3GK2V1sgg4grvDBbmKd5H8dsTmo", "11111111111111111111111111111111", "ComputeBudget111111111111111111111111111111", "JUP6LkbZbjS1jKKwapdHNy74zcZ3tLUZoi5QNyVTaV4", "So11111111111111111111111111111111111111112", "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA", "2MFoS3MPtvyQ4Wh4M9pdfPjz6UhVoNbFbGJAskCPCj3h", "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL", "BKQoRwtpzKyjKqxbUe9VZmXoBtjwsJFRoAKu1sweVoDM", "D8cy77BBepLMngZx6ZukaTff5hCt1HrWyKk3Hnd9oitf"],
                "addressTableLookups": [{
                    "accountKey": "2u6yFcyRpzen9RH3bwSiGbjCYS7bJi9rdPA7A5KLyyd2",
                    "readonlyIndexes": [27, 2, 25, 32],
                    "writableIndexes": [31, 34, 24, 28, 30, 33, 26, 29, 23, 36]
                }],
                "header": {
                    "numReadonlySignedAccounts": 0,
                    "numReadonlyUnsignedAccounts": 9,
                    "numRequiredSignatures": 1
                },
                "instructions": [{
                    "accounts": [],
                    "data": "KQ8HXm",
                    "programIdIndex": 6,
                    "stackHeight": null
                }, {
                    "accounts": [],
                    "data": "3inRozWPKQF9",
                    "programIdIndex": 6,
                    "stackHeight": null
                }, {
                    "accounts": [0, 3, 0, 8, 5, 9],
                    "data": "2",
                    "programIdIndex": 11,
                    "stackHeight": null
                }, {
                    "accounts": [0, 3],
                    "data": "3Bxs3zwz7cee1YBq",
                    "programIdIndex": 5,
                    "stackHeight": null
                }, {
                    "accounts": [3],
                    "data": "J",
                    "programIdIndex": 9,
                    "stackHeight": null
                }, {
                    "accounts": [0, 2, 0, 12, 5, 9],
                    "data": "2",
                    "programIdIndex": 11,
                    "stackHeight": null
                }, {
                    "accounts": [9, 10, 0, 3, 4, 1, 2, 8, 12, 7, 7, 13, 7, 26, 9, 23, 25, 18, 20, 22, 24, 21, 17, 15, 19, 16, 14, 27, 4, 1, 10],
                    "data": "2U4BQZ7jhoZZHerbnDCg7XKVeivkMLKu738LJmcgEsgfZ5Yeb1",
                    "programIdIndex": 7,
                    "stackHeight": null
                }, {
                    "accounts": [3, 0, 0],
                    "data": "A",
                    "programIdIndex": 9,
                    "stackHeight": null
                }],
                "recentBlockhash": "FMaQHhpF3Xd7PkxwQ1CFQR2aEpu2bK9rdTXFenv3rzQZ"
            },
            "signatures": ["5DmrWBydDod85swXUp3sRVmuQW1VUwBFdVyKRybeKduaUEbwEJGFY6CwZo9xni2jsBcyrHjAA7N6W9Mz93KCneQc"]
        },
        "version": 0
    },
    "id": 1
}
"""
