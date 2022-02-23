import pytest
from brownie import PositionMaker, reverts, history


@pytest.fixture(scope='module')
def steth(interface):
    return interface.StETH('0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84')

@pytest.fixture(scope='module')
def wsteth(interface):
    return interface.WstETH('0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0')

@pytest.fixture(scope='module')
def weth(interface):
    return interface.WETH('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2')

@pytest.fixture(scope='module')
def actor(accounts):
    return accounts[0]

def test_position(actor, steth, wsteth, weth):
    amount = 10**18
    steth.submit(actor, {"from": actor, "amount": 2*amount})
    steth.approve(wsteth, 2*amount, {"from": actor})
    wsteth.wrap(2*amount, {"from": actor})
    weth.deposit({"from": actor, "amount": amount})
    positionMaker = PositionMaker.deploy({"from": actor})
    wsteth.transfer(positionMaker, amount, {"from": actor})
    weth.transfer(positionMaker, amount, {"from": actor})
    positionMaker.createPosition(amount, amount)
    print(positionMaker.position())