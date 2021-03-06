package game.entities;

import game.Sprite;
import game.util.EPlayer;

import kha.Assets;
import kha.System;
import kha.graphics2.Graphics;
import kha.math.Random;

class Ball extends Sprite {
    var minX : Float;
    var minY : Float;
    var maxX : Float;
    var maxY : Float;
    var dx : Int;
    var dy : Int;
    var v : Float;
    var resolvedCollision : Bool;
    
    public function new(x, y) {
        super(x, y, Assets.images.ball);
        positionCenter(x, y);
        
        Random.Default.GetIn(0, 1) == 0 ? dx = -1 : dx = 1;
        Random.Default.GetIn(0, 1) == 0 ? dy = -1 : dy = 1;
        
        minX = minY = 0;
        maxX = System.windowWidth() - width;
        maxY = System.windowHeight() - height;
        
        v = 4;
        resolvedCollision = false;
    }
    
    override public function update() : Void {
        if (!active) return;
        
        x += dx * v;
        y += dy * v;
        
        if (x < minX || x > maxX) dx *= -1;
        if (y < minY || y > maxY) {
            dy *= -1;
            if (dx == 0) {
                dx = (x < System.windowWidth() / 2) ? 1 : -1; 
            }
        }
        
        if (!isOverlapping && resolvedCollision) {
            resolvedCollision = false;
        }
    }
    
    override public function draw(g : Graphics) : Void {
        if (!visible) return;
        
        super.draw(g);
    }
    
    public inline function setMovementBounds(minX : Float, minY : Float, maxX : Float, maxY : Float) : Void {
        this.minX = minX;
        this.minY = minY;
        this.maxX = maxX - width;
        this.maxY = maxY - height;
    }
    
    public inline function resolvePlayerCollision(p : Player) : Void {
        if (overlapsEntity(p)) {
            if (!resolvedCollision) {
                resolvedCollision = true;
                dx = (p.player == EPlayer.PLAYER_1) ? 1 : -1;
                dy = ((y - height) < (p.y + p.height / 2 - height)) ? -1 : 1;
            }
        }
    }
    
    public inline function resolveBasketCollision(b : Basket) : Void {
        if (overlapsEntity(b)) {
            if (!resolvedCollision) {
                resolvedCollision = true;
                if (dy == 1) {
                    if (((x + width * 1 / 2) < (b.x + b.width)) && ((x + width * 1 / 2) > b.x)) {
                        b.ballsPassed += 1;
                        dx = 0;
                    } else {
                        dx *= -1; 
                    }
                } else {
                    dx *= -1;
                }
            }
        }
    }
}
