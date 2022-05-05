import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cielo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(lataEnergizante)
	
		keyboard.space().onPressDo{ self.jugar(dino)}
		keyboard.space().onPressDo{ self.jugar(megaDino)}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method    iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		lataEnergizante.iniciar()
	}
	
	method jugar(dinosaurio){
		if (dinosaurio.estaVivo()) 
			dinosaurio.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		lataEnergizante.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object cactus {
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object cielo {
	method position() = game.origin().up(1)
	
	method image() = "cielo3.png"
}

object cieloNocturno {
	method position() = game.origin().up(1)
	
	method image() = "cieloNocturno.png"
}

object suelo{
	
	method position() = game.origin()
	
	method image() = "arena2.png"
}

object sueloNocturno{
	
	method position() = game.origin()
	
	method image() = "arenaNocturna2.png"
}


object dino {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}

object megaDino {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	method image() = "megaDino2.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*6,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(2)
	}
	
	method bajar(){
		position = position.down(2)
	}
	
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}

object lataEnergizante {
	const posicionInicial = game.at((game.width()-3) ,suelo.position().y())
	var position = posicionInicial
	
	method image() = "lataEnergizante3.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverLata",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -42)
			position = posicionInicial
	}
	
	method chocar() {
		game.removeVisual(cielo)
		game.addVisual(cieloNocturno)
		game.removeVisual(suelo)
		game.addVisual(sueloNocturno)
		game.removeVisual(cactus)
		game.addVisual(cactus)
		game.removeVisual(reloj)
		game.addVisual(reloj)
		game.removeVisual(dino)
		game.addVisual(megaDino)
		game.onTick(7500, "destransformar", {self.destransformar()})
	}
	
	method destransformar() {
		game.removeVisual(cieloNocturno)
		game.addVisual(cielo)
		game.removeVisual(sueloNocturno)
		game.addVisual(suelo)
		game.removeVisual(cactus)
		game.addVisual(cactus)
		game.removeVisual(reloj)
		game.addVisual(reloj)
		game.removeVisual(lataEnergizante)
		game.addVisual(lataEnergizante)
		game.removeVisual(megaDino)
		game.addVisual(dino)
		game.removeTickEvent("destransformar")
	}
	
	method detener(){
		game.removeTickEvent("moverLata")
	}
}