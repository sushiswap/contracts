import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('ProxyFactory', function() {
  it('Emits ProxyCreated with expected arguments', async function() {
    const ProxySubject = await ethers.getContractFactory('ProxySubject')
    const proxySubject = await ProxySubject.deploy()

    await proxySubject.deployed()

    const ProxyFactory = await ethers.getContractFactory('ProxyFactory')
    const proxyFactory = await ProxyFactory.deploy(proxySubject.address)

    await proxyFactory.deployed()

    await expect(proxyFactory.createProxy('foo'))
      .to.emit(proxyFactory, 'ProxyCreated')
      .withArgs('0xd8058efe0198ae9dD7D563e1b4938Dcbc86A1F81', 'foo')
  })
})
