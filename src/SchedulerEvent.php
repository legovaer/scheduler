<?php
/**
 * Created by PhpStorm.
 * User: legovaer
 * Date: 11/03/16
 * Time: 15:37
 */

namespace Drupal\scheduler;


use Drupal\Core\Entity\EntityInterface;
use Symfony\Component\EventDispatcher\Event;

class SchedulerEvent extends Event {

  /** @var EntityInterface $node */
  protected $node;

  public function __construct(EntityInterface $node) {
    $this->node = $node;
  }
}